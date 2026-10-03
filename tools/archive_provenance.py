"""Stable archive content identity, excluding the manifest that records it."""
import hashlib


def content_digest(entries, scope):
    prefix = scope.rstrip("/") + "/"
    rows = sorted(
        [entry["path"], entry["mode"], entry["type"], entry["sha"]]
        for entry in entries
        if entry["path"].startswith(prefix)
        and entry["path"] != prefix + "project-manifest.json"
        and entry["type"] != "tree"
    )
    if not rows:
        raise ValueError("Archive content scope is empty")
    return hashlib.sha256("\n".join("\0".join(row) for row in rows).encode()).hexdigest()
