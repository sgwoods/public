"""Validate and render approved daily aggregates without reading private sources."""
import html
import json
import re
from datetime import date, datetime, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo


LOCAL_TZ = ZoneInfo("America/Toronto")
CATEGORIES = ("development", "publication", "automation", "unclassified")
KEYS = {"schema_version", "project_id", "generated_at", "checked_at", "timezone",
        "scope", "report_basis", "uncommitted_work", "window_start", "window_end", "days"}
SCOPES = {
    "working-default-branch": "Working default-branch history",
    "working-all-branches": "Working branch histories, deduplicated",
    "contribution-branches": "Own contributions only; upstream work excluded",
}
BASES = {"hub-assisted-baseline": "Baseline only; source export not yet established",
         "owner-approved-export": "Owner-approved source export"}


def timestamp(value):
    if not isinstance(value, str):
        raise ValueError("Working report timestamps must be strings")
    try:
        parsed = datetime.fromisoformat(value.replace("Z", "+00:00"))
    except ValueError:
        raise ValueError("Invalid working report timestamp") from None
    if parsed.tzinfo is None:
        raise ValueError("Working report timestamps require a timezone")
    return parsed.astimezone(timezone.utc)


def calendar_date(value):
    if not isinstance(value, str) or not re.fullmatch(r"\d{4}-\d{2}-\d{2}", value):
        raise ValueError("Working report dates must use YYYY-MM-DD")
    return date.fromisoformat(value)


def validate(report, project_ids, now=None):
    now = now or datetime.now(timezone.utc)
    if not isinstance(report, dict) or set(report) != KEYS:
        raise ValueError("Working report must use the documented aggregate-only field allowlist")
    if report["schema_version"] != "1.0" or report["project_id"] not in project_ids:
        raise ValueError("Working report needs a registered project and schema 1.0")
    if report["timezone"] != "America/Toronto":
        raise ValueError("Working report dates use America/Toronto")
    if report["scope"] not in SCOPES or report["report_basis"] not in BASES:
        raise ValueError("Working report scope and basis must be explicit")
    if report["project_id"] == "firstmate" and report["scope"] != "contribution-branches":
        raise ValueError("Firstmate reports must exclude upstream developers' work")
    if report["uncommitted_work"] not in {"present", "absent", "not_checked"}:
        raise ValueError("Uncommitted work must be described without exposing files")
    checked, generated = timestamp(report["checked_at"]), timestamp(report["generated_at"])
    if checked > generated or generated > now + timedelta(minutes=5):
        raise ValueError("Working report check/export times are inconsistent or in the future")
    start, end = calendar_date(report["window_start"]), calendar_date(report["window_end"])
    if not 1 <= (end - start).days <= 56 or end > checked.astimezone(LOCAL_TZ).date() + timedelta(days=1):
        raise ValueError("Working report window must cover 1-56 checked local dates")
    days = report["days"]
    if not isinstance(days, list) or len(days) != (end - start).days:
        raise ValueError("Every date needs an explicit row; missing dates are not zero")
    for offset, row in enumerate(days):
        if not isinstance(row, dict) or set(row) != {"date", *CATEGORIES}:
            raise ValueError("Daily rows permit only a date and four aggregate counts")
        if calendar_date(row["date"]) != start + timedelta(days=offset):
            raise ValueError("Daily rows must be complete, unique, and ascending")
        if any(type(row[key]) is not int or not 0 <= row[key] <= 1000000 for key in CATEGORIES):
            raise ValueError("Daily counts must be nonnegative integers, not estimates or booleans")


def project_registry(projects):
    # Archives retain their separate public-content view; this lens covers software work.
    result = {project.project_id: {"name": project.display_name, "href": project.project_page_href}
              for project in projects}
    result["firstmate"] = {"name": "Firstmate contributions (supporting tooling)",
                           "href": "https://github.com/sgwoods/firstmate"}
    return result


def load_reports(root: Path, registry, now=None):
    reports = {}
    for path in sorted((root / "data/activity").glob("*.json")):
        report = read_report(path)
        validate(report, registry, now)
        if path.stem != report["project_id"]:
            raise ValueError("Working report filename must match its registered project id")
        reports[path.stem] = report
    return reports


def read_report(path):
    def unique_keys(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError("Duplicate JSON field in working report")
            result[key] = value
        return result
    return json.loads(path.read_text(), object_pairs_hook=unique_keys)


def totals(report):
    return {key: sum(row[key] for row in report["days"]) for key in CATEGORIES}


def render(projects, root: Path, now=None):
    now = now or datetime.now(timezone.utc)
    registry = project_registry(projects)
    reports = load_reports(root, registry, now)
    escape = html.escape
    rows, details = [], []
    for key, project in registry.items():
        name = escape(project["name"])
        link = f'<a href="{escape(project["href"], quote=True)}">{name}</a>'
        report = reports.get(key)
        if not report:
            rows.append(f'<tr><td>{link}</td><td>Awaiting source report</td><td>N/A</td>'
                        '<td>Unknown, not zero</td><td>Not reported</td></tr>')
            continue
        counts = totals(report)
        checked = timestamp(report["checked_at"])
        checked_text = checked.astimezone(LOCAL_TZ).strftime("%B %-d, %Y at %-I:%M %p")
        stale = now - checked > timedelta(days=8)
        state = BASES[report["report_basis"]] + ("; report over eight days old" if stale else "")
        last_day = calendar_date(report["window_end"]) - timedelta(days=1)
        period = f'{report["window_start"]} through {last_day.isoformat()}'
        breakdown = (f'{counts["development"]} classified development; {counts["publication"]} publication; '
                     f'{counts["automation"]} automation; {counts["unclassified"]} unclassified')
        rows.append(f'<tr><td>{link}<br>{escape(SCOPES[report["scope"]])}</td>'
                    f'<td>{escape(period)}</td><td>{sum(counts.values())}</td>'
                    f'<td>{escape(breakdown)}</td><td>{escape(checked_text)}<br>{escape(state)}</td></tr>')
        daily = "".join('<tr><td>' + row["date"] + '</td>' +
                        ''.join(f'<td>{row[category]}</td>' for category in CATEGORIES) + '</tr>'
                        for row in reversed(report["days"]))
        details.append(f'''<details class="workingActivityDetails" data-working-project="{escape(key)}">
            <summary>{name}: daily working activity ({escape(period)})</summary>
            <p>{escape(state)}. Uncommitted work: {escape(report["uncommitted_work"].replace("_", " "))}.
            Current-day counts are partial through the recorded check time. Zero classified development
            does not mean no coding when unclassified commits remain. No daily row implies a release.</p>
            <div class="repositoryTable"><table><caption>{name}: daily commit categories, America/Toronto</caption>
            <thead><tr><th scope="col">Date</th><th scope="col">Classified development</th>
            <th scope="col">Publication</th><th scope="col">Automation</th><th scope="col">Unclassified</th></tr></thead>
            <tbody>{daily}</tbody></table></div>
            <p><a href="data/activity/{escape(key)}.json">Approved aggregate report</a></p>
        </details>''')
    return f'''<section class="panel" id="working-activity">
            <h2>Working Activity</h2>
            <p>Privacy-safe daily summaries of working histories, separate from public default-branch commits
            and released snapshots. Reports can cover committed local/private work and own contributions.
            They do not count uncommitted edits, hours, effort, or release readiness. Never add these totals
            to the public charts: the same work may appear in both views.</p>
            <p>Each row has its own fixed reporting window. Missing reports are unknown, not zero.
            Unclassified commits can include code, content, publication, and automated backups;
            they are not all coding. The hub never advances source report times during rendering.</p>
            <div class="repositoryTable"><table><caption>Working-history coverage and reported commit counts</caption>
            <thead><tr><th scope="col">Project / scope</th><th scope="col">Reported window</th>
            <th scope="col">Working commits</th><th scope="col">Classification</th>
            <th scope="col">Report checked / coverage</th></tr></thead><tbody>{''.join(rows)}</tbody></table></div>
            {''.join(details)}
            <p><a href="WORKING-ACTIVITY-INTERFACE.md">Privacy and export interface</a> ·
            <a href="REPOSITORY-HANDOFFS.md">One-at-a-time setup queue</a></p>
        </section>'''


def main():
    import argparse
    import render_index
    import render_project_suite_overview
    parser = argparse.ArgumentParser(description="Validate approved aggregate working reports without reading source histories")
    parser.add_argument("--check-file", type=Path, help="Check a prepared report before publishing it")
    args = parser.parse_args()
    coding, _ = render_index.classify_projects(render_project_suite_overview.load_projects())
    registry = project_registry(coding)
    try:
        if args.check_file:
            report = read_report(args.check_file)
            validate(report, registry)
            print(f'Valid working report: {report["project_id"]}; {sum(totals(report).values())} aggregate commits')
        else:
            reports = load_reports(render_index.ROOT, registry)
            print(f"Validated {len(reports)} working reports; {len(registry) - len(reports)} awaiting source reports")
    except (ValueError, TypeError, KeyError, OSError):
        raise SystemExit("Working report validation failed; check the documented allowlist, dates, coverage, and counts. No report published.") from None


if __name__ == "__main__":
    main()
