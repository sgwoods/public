const { test } = require("node:test");
const assert = require("node:assert/strict");
const { countsForProject, dedupeProjects, projectSortFactory, sourceComparison } = require("../assets/public-index.js");
const { renderProjectCard, privateDetails } = require("../assets/public-index.js");
const privateManifest = {
    project_id: "financial-planner", display_name: "Financial Planner", repo_pushed_at: null,
    status_generated_at: "2026-10-22T17:53:59Z", status_label: "Public status",
    status_value: "Private development", focus_label: "Scope", focus_value: "Personal planning",
    private_metadata: {
        checked_at: "2026-10-22T17:49:22Z", report_basis: "Hub-assisted metadata review",
        last_default_branch_commit_at: "2026-09-27T13:37:15Z", release_version: null, released_at: null,
        activity: { window_start: "2026-08-31T04:00:00Z", window_end: "2026-10-22T17:49:22Z", commit_count: 63 },
    },
};

test("private cards expose only sanitized metadata, never a fake release snapshot", () => {
    const card = renderProjectCard({ ...privateManifest, project_page_href: "financial-planner.html" });
    assert.match(card, /Metadata checked/);
    assert.match(card, /63 commits;/);
    assert.match(card, /Not verified; no release claimed/);
    assert.doesNotMatch(card, /Reported snapshot date|Repository checked|Open repository|1970/);
    const details = privateDetails({ ...privateManifest.private_metadata, activity: null, checked_at: "2020-01-01T00:00:00Z" });
    assert.match(details.flat().join(" "), /Not reported \(not zero\)/);
    assert.match(details.flat().join(" "), /over eight days old/);
});

test("published metrics use committer dates, deduplicate SHAs, and respect local-day boundaries", () => {
    const project = { project_id: "ai-briefing", repo: "sgwoods/news-pipeline", paths: [], exclude_paths: [] };
    const row = { state: "ok", repo: project.repo, paths: [], exclude_paths: [],
        checked_at: "2026-10-22T18:00:00Z", window_start: "2026-08-31T04:00:00Z",
        commits: [{ sha: "a", date: "2026-10-22T03:59:59Z" }, { sha: "a", date: "2026-10-22T03:59:59Z" },
                  { sha: "b", date: "2026-10-22T04:00:00Z" }] };
    const starts = [new Date("2026-10-21T00:00:00-04:00"), new Date("2026-10-22T00:00:00-04:00")];
    const ends = [starts[1], new Date("2026-10-23T00:00:00-04:00")];
    assert.deepEqual(countsForProject(project, row, starts, ends), [1, 1]);
    assert.deepEqual(countsForProject(project, { ...row, state: "check_failed" }, starts, ends), [null, null]);
    assert.deepEqual(countsForProject(project, null, starts, ends), [null, null]);
    assert.deepEqual(countsForProject(project, { ...row, commits: [] }, starts, ends), [0, 0]);
});

test("an archive scope or date-window change cannot reuse incompatible history", () => {
    const project = { repo: "sgwoods/public", paths: ["quack"], exclude_paths: ["quack/project-manifest.json"] };
    const start = [new Date("2026-10-21T04:00:00Z")];
    const end = [new Date("2026-10-22T04:00:00Z")];
    const row = { state: "ok", repo: project.repo, paths: ["quack"], exclude_paths: [], commits: [],
        checked_at: "2026-10-22T18:00:00Z", window_start: "2026-10-01T00:00:00Z" };
    assert.deepEqual(countsForProject(project, row, start, end), [null]);
    row.exclude_paths = project.exclude_paths;
    row.window_start = "2026-10-22T04:00:00Z";
    assert.deepEqual(countsForProject(project, row, start, end), [null]);
});

test("manifest cards deduplicate bridges and retain the registered AI Briefing order", () => {
    const projects = dedupeProjects([
        { project_id: "quack-com", active: true, repo_pushed_at: "2026-05-11T00:00:00Z", status_generated_at: "2026-10-03T00:00:00Z" },
        { project_id: "quack-com", active: true, repo_pushed_at: "2026-05-11T00:00:00Z", status_generated_at: "2026-10-04T00:00:00Z", status_value: "New bridge" },
        { project_id: "ai-briefing", active: true }, { project_id: "ai-dystopia-quotes", active: true },
    ]);
    projects.sort(projectSortFactory({ project_order: ["ai-dystopia-quotes", "ai-briefing", "quack-com"] }));
    assert.deepEqual(projects.map((p) => p.project_id), ["ai-dystopia-quotes", "ai-briefing", "quack-com"]);
    assert.equal(projects[2].status_value, "New bridge");
});

test("a new manifest cannot inherit a match from an older observation", () => {
    assert.match(sourceComparison({ source_commit: "new" }, { snapshot_commit: "old", state: "matches" }), /comparison pending/);
    assert.match(sourceComparison({ source_commit: "same" }, { snapshot_commit: "same", state: "check_failed" }), /Check failed/);
    assert.match(sourceComparison({ source_commit: "same", source_dirty: true }, { snapshot_commit: "same", state: "matches" }), /uncommitted changes/);
});
