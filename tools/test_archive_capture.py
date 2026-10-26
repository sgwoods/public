#!/usr/bin/env python3
import hashlib
import json
from pathlib import Path
import sys
import unittest
from unittest.mock import Mock, patch
from capture_archive_source import render_capture


class CaptureTests(unittest.TestCase):
    def capture(self, raw, **kwargs):
        args = dict(title="Evidence", source_url="https://example.org/source",
                    retrieved_url="https://example.org/new/source", checked_on="2026-10-26",
                    tag="article", license_note="Attribution retained; rights remain with source.",
                    method="public-http", expected=["evidence"])
        args.update(kwargs)
        return render_capture(raw.encode(), **args)

    def test_active_content_and_hidden_script_data_excluded(self):
        page, meta = self.capture('<article><h1>Evidence</h1><script>SECRET</script><form>PRIVATE</form><svg>TRACKER</svg><p onclick="bad()">' + 'Public source text. ' * 10 + '</p><a href="/reference">Reference</a><a href="javascript:bad()">Bad</a></article>')
        for token in ("SECRET", "PRIVATE", "TRACKER", "onclick", "javascript:"):
            self.assertNotIn(token, page)
        self.assertIn("https://example.org/reference", page)
        self.assertEqual(meta["capture_sha256"], hashlib.sha256(page.encode()).hexdigest())

    def test_selector_requires_exactly_one_region(self):
        for raw in ("<p>Not found</p>", "<article>Evidence</article><article>Evidence</article>"):
            with self.assertRaises(ValueError):
                self.capture(raw)

    def test_expected_evidence_prevents_error_page_capture(self):
        with self.assertRaises(ValueError):
            self.capture("<article>" + "Login required. " * 30 + "</article>")

    def test_class_selection_and_nested_content(self):
        page, _ = self.capture('<div><article class="source extra"><article><p>' + 'Evidence. ' * 30 + '</p></article></article></div>', attribute="class", value="source")
        self.assertIn("Evidence.", page)

    def test_source_html_is_escaped(self):
        page, _ = self.capture("<article>" + "Evidence &lt;script&gt;alert(1)&lt;/script&gt;. " * 10 + "</article>")
        self.assertNotIn("<script>", page)
        self.assertIn("&lt;script&gt;", page)

    def test_invalid_date_and_scheme_fail(self):
        for overrides in (dict(checked_on="not-a-date"), dict(source_url="file:///private")):
            with self.assertRaises(ValueError):
                self.capture("<article>" + "Evidence. " * 30 + "</article>", **overrides)

    def test_preserved_captures_match_provenance(self):
        root = Path(__file__).resolve().parents[1]
        sidecars = list(root.glob("*/historic/artifacts/archive-html/*.capture.json"))
        self.assertGreaterEqual(len(sidecars), 6)
        for sidecar in sidecars:
            with self.subTest(path=sidecar):
                metadata = json.loads(sidecar.read_text())
                capture = Path(str(sidecar).removesuffix(".capture.json"))
                self.assertEqual(hashlib.sha256(capture.read_bytes()).hexdigest(), metadata["capture_sha256"])
                self.assertIn("not the source publication date", capture.read_text())

    def test_quack_regeneration_retains_captures_and_uses_live_count(self):
        root = Path(__file__).resolve().parents[1]
        sys.path.insert(0, str(root / "quack/tools"))
        import quack_research_pipeline as q
        sources = q.make_source_manifest(q.load_leads()["leads"])
        committed_sources = json.loads((root / "quack/source-manifest.json").read_text())
        self.assertEqual(sources, committed_sources)
        approved = [source for source in sources["sources"] if source["status"] == "approved"]
        self.assertTrue(all(source["urls"]["archive_local"] for source in approved))
        approved[0]["urls"]["archive_local"] = None
        output = Mock()
        with patch.object(q, "PROJECT_PAGE_OUTPUT", output):
            q.render_project_page(q.read_json(q.PROJECT_MANIFEST_PATH, {}), sources,
                                  q.read_json(q.TIMELINE_PATH, {}), q.read_json(q.ENTITIES_PATH, {}))
        rendered = output.write_text.call_args.args[0]
        self.assertIn(f"{len(approved) - 1} of {len(approved)} approved sources", rendered)


if __name__ == "__main__":
    unittest.main()
