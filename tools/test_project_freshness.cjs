const { test } = require("node:test");
const assert = require("node:assert/strict");
const { readFileSync } = require("node:fs");
const vm = require("node:vm");
const { describe } = require("../assets/project-freshness.js");

const source = "a".repeat(40);
const now = Date.parse("2026-10-22T15:00:00Z");
const observation = {
    state: "matches", branch: "main", commit: source, snapshot_commit: source,
    checked_at: "2026-10-22T12:52:26Z", commit_date: "2026-10-20T10:00:00Z",
    snapshot_date: "2026-10-20T10:00:00Z",
};

test("the page's source identity must match the observed snapshot", () => {
    assert.match(describe(source, false, observation, now).join(" "), /matched this page's exported source/);
    assert.match(describe("b".repeat(40), false, observation, now).join(" "), /different snapshot/);
    assert.doesNotMatch(describe(source, true, observation, now).join(" "), /matched this page/);
});

test("development differences never promote a release", () => {
    const newer = { ...observation, commit: "b".repeat(40), state: "different_commit", commit_date: "2026-10-21T10:00:00Z" };
    const text = describe(source, false, newer, now).join(" ");
    assert.match(text, /A newer commit exists on main/);
    assert.match(text, /review signal/);
    assert.doesNotMatch(text, /out of date/);
    assert.doesNotMatch(describe(source, false, { ...newer, commit_date: "2026-10-19T10:00:00Z" }, now).join(" "), /A newer commit/);
});

test("failures and missing checks cannot claim freshness", () => {
    assert.match(describe(source, false, null, now).join(" "), /not yet recorded/);
    const failed = describe(source, false, { ...observation, state: "check_failed" }, now).join(" ");
    assert.match(failed, /latest repository check failed/);
    assert.doesNotMatch(failed, /matched this page/);
    assert.match(describe(source, false, { ...observation, checked_at: "2026-10-01T10:00:00Z" }, now).join(" "), /over eight days old/);
});

test("the widget fetches hub data and uses text nodes even for untrusted values", async () => {
    const panel = { dataset: { projectFreshness: "ai-briefing", sourceCommit: source, sourceDirty: "false" },
        replaceChildren(...children) { this.children = children; } };
    let request;
    vm.runInNewContext(readFileSync(require.resolve("../assets/project-freshness.js"), "utf8"), {
        document: { currentScript: { src: "https://sgwoods.github.io/public/assets/project-freshness.js" },
            querySelectorAll: () => [panel], createElement: (tag) => ({ tag }) },
        URL, Intl, Date,
        fetch: async (url, options) => {
            request = { url, options };
            return { ok: true, json: async () => ({ projects: {
                "ai-briefing": { ...observation, branch: "<script>bad</script>" },
            } }) };
        },
    });
    await new Promise(setImmediate);
    assert.equal(request.url, "https://sgwoods.github.io/public/data/shared/repository-observations.json");
    assert.equal(request.options.cache, "no-store");
    assert.ok(panel.children.some((child) => child.textContent?.includes("<script>bad</script>")));
    assert.ok(panel.children.every((child) => child.innerHTML === undefined));
});

test("a network failure replaces a previous success with an explicit unavailable message", async () => {
    const panel = { dataset: {}, replaceChildren(...children) { this.children = children; } };
    vm.runInNewContext(readFileSync(require.resolve("../assets/project-freshness.js"), "utf8"), {
        document: { currentScript: { src: "https://sgwoods.github.io/public/assets/project-freshness.js" },
            querySelectorAll: () => [panel], createElement: (tag) => ({ tag }) },
        URL, Intl, Date, fetch: async () => { throw new Error("offline"); },
    });
    await new Promise(setImmediate);
    assert.ok(panel.children.some((child) => /could not be loaded/.test(child.textContent)));
});
