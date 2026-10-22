(() => {
    "use strict";

    const format = (value) => new Intl.DateTimeFormat("en-CA", {
        dateStyle: "long", timeStyle: "short", timeZone: "America/Toronto",
    }).format(new Date(value));

    function describe(sourceCommit, sourceDirty, observation, now = Date.now()) {
        if (!observation) return ["The hub has not yet recorded a repository check for this project."];
        const messages = [];
        const checked = Date.parse(observation.checked_at);
        if (Number.isFinite(checked)) {
            messages.push(`Hub last successfully checked: ${format(checked)} (America/Toronto).`);
            if (now - checked > 8 * 86400000) messages.push("This observation is over eight days old; another check is needed.");
        } else {
            messages.push("The hub has not yet completed a successful repository check for this project.");
        }
        const branch = observation.branch || "default";
        const commit = observation.commit || "";
        if (observation.state === "check_failed") {
            messages.push("The latest repository check failed; a current comparison is unavailable. Any prior observation is retained.");
        } else if (observation.state === "not_observed") {
            messages.push("No public repository observation is configured.");
        } else if (!Number.isFinite(checked) || !commit) {
            messages.push("A comparison with this page's published source has not been established.");
        } else if (!sourceCommit || observation.state === "awaiting_export") {
            messages.push("Awaiting the project's first verified source export; a release match cannot be established.");
        } else if (observation.snapshot_commit !== sourceCommit) {
            messages.push("The last hub check refers to a different snapshot; this page needs another check.");
        } else if (sourceDirty || observation.state === "dirty_snapshot") {
            messages.push("The published snapshot includes uncommitted changes; its commit alone cannot establish a match.");
        } else if (commit === sourceCommit) {
            messages.push(`At that check, the observed ${branch} branch matched this page's exported source (${commit.slice(0, 7)}).`);
        } else {
            const newer = Date.parse(observation.commit_date) > Date.parse(observation.snapshot_date);
            messages.push(newer
                ? `A newer commit exists on ${branch} (${commit.slice(0, 7)}).`
                : `The observed ${branch} commit (${commit.slice(0, 7)}) differs from this page's exported source.`);
            messages.push("This is a review signal; it does not establish a new published release.");
        }
        if (Number.isFinite(Date.parse(observation.commit_date)) && Number.isFinite(checked)) {
            messages.push(`Observed commit dated ${format(observation.commit_date)} (America/Toronto).`);
        }
        return messages;
    }

    if (typeof module !== "undefined") module.exports = { describe };
    if (typeof document === "undefined") return;
    const panels = [...document.querySelectorAll("[data-project-freshness]")];
    if (!panels.length) return;
    const assetUrl = document.currentScript.src;
    const observationsUrl = new URL("../data/shared/repository-observations.json", assetUrl);
    const activityUrl = new URL("../index.html#repository-activity", assetUrl);

    function display(panel, messages) {
        const heading = document.createElement("h2");
        heading.textContent = "Repository freshness";
        const paragraphs = messages.map((message) => {
            const p = document.createElement("p");
            p.textContent = message;
            return p;
        });
        const link = document.createElement("a");
        link.href = activityUrl.href;
        link.textContent = "Portfolio repository activity";
        panel.replaceChildren(heading, ...paragraphs, link);
    }

    fetch(observationsUrl.href, { cache: "no-store" })
        .then((response) => {
            if (!response.ok) throw new Error("Observation request failed");
            return response.json();
        })
        .then((data) => {
            if (!data.projects || typeof data.projects !== "object") throw new Error("Invalid observations");
            panels.forEach((panel) => display(panel, describe(
                panel.dataset.sourceCommit, panel.dataset.sourceDirty !== "false",
                data.projects[panel.dataset.projectFreshness],
            )));
        })
        .catch(() => panels.forEach((panel) => display(panel, [
            "The latest hub observation could not be loaded. A current repository comparison is unavailable.",
        ])));
})();
