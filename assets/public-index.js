(() => {
    const SITE_TZ = "America/Toronto";

    function parseJsonScript(id) {
        const node = document.getElementById(id);
        if (!node) {
            return null;
        }

        try {
            return JSON.parse(node.textContent);
        } catch (error) {
            return null;
        }
    }

    function formatLocalDate(value) {
        return new Intl.DateTimeFormat("en-CA", {
            dateStyle: "long",
            timeZone: SITE_TZ,
        }).format(new Date(value));
    }

    function formatLocalDateTime(value) {
        return new Intl.DateTimeFormat("en-CA", {
            dateStyle: "long",
            timeStyle: "short",
            timeZone: SITE_TZ,
        }).format(new Date(value));
    }

    function projectSortFactory(config) {
        const order = new Map((config.project_order || []).map((projectId, index) => [projectId, index]));
        return (left, right) => {
            const leftRank = order.has(left.project_id) ? order.get(left.project_id) : Number.MAX_SAFE_INTEGER;
            const rightRank = order.has(right.project_id) ? order.get(right.project_id) : Number.MAX_SAFE_INTEGER;
            if (leftRank !== rightRank) {
                return leftRank - rightRank;
            }
            return (left.display_name || "").localeCompare(right.display_name || "");
        };
    }

    function projectTimestamp(project, field) {
        const value = project && project[field] ? Date.parse(project[field]) : NaN;
        return Number.isNaN(value) ? 0 : value;
    }

    function normalizeProject(payload) {
        const timelineLabel = payload?.timeline_span?.label || null;
        return {
            ...payload,
            project_page_href: payload.project_page_url || payload.project_page_path || "",
            repo_url: payload.repo_url || null,
            person_context: payload.person_context || null,
            timeline_label: timelineLabel,
            status_label: payload.status_label || "Current phase",
            status_value: payload.status_value || timelineLabel || "Archive project",
            focus_label: payload.focus_label || "Current focus",
            focus_value: payload.focus_value || payload.current_focus || "Archive organization",
        };
    }

    function projectRank(project) {
        return [
            projectTimestamp(project, "status_generated_at"),
            projectTimestamp(project, "repo_pushed_at"),
            project.person_context ? 1 : 0,
            project.repo_url ? 1 : 0,
            project.project_id || "",
        ];
    }

    function dedupeProjects(projects) {
        const latestById = new Map();
        for (const rawProject of projects) {
            const project = normalizeProject(rawProject);
            const existing = latestById.get(project.project_id);
            if (!existing) {
                latestById.set(project.project_id, project);
                continue;
            }

            const candidateTuple = projectRank(project);
            const existingTuple = projectRank(existing);
            if (
                candidateTuple[0] > existingTuple[0] ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] > existingTuple[1]) ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] === existingTuple[1] && candidateTuple[2] > existingTuple[2]) ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] === existingTuple[1] && candidateTuple[2] === existingTuple[2] && candidateTuple[3] > existingTuple[3]) ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] === existingTuple[1] && candidateTuple[2] === existingTuple[2] && candidateTuple[3] === existingTuple[3] && candidateTuple[4] > existingTuple[4])
            ) {
                latestById.set(project.project_id, project);
            }
        }

        const latestByRepo = new Map();
        const passthrough = [];

        for (const project of latestById.values()) {
            const key = (project.repo_url || "").trim().toLowerCase();
            if (!key) {
                passthrough.push(project);
                continue;
            }

            const existing = latestByRepo.get(key);
            if (!existing) {
                latestByRepo.set(key, project);
                continue;
            }

            const candidateTuple = [
                projectTimestamp(project, "status_generated_at"),
                projectTimestamp(project, "repo_pushed_at"),
                project.project_id || "",
            ];
            const existingTuple = [
                projectTimestamp(existing, "status_generated_at"),
                projectTimestamp(existing, "repo_pushed_at"),
                existing.project_id || "",
            ];

            if (
                candidateTuple[0] > existingTuple[0] ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] > existingTuple[1]) ||
                (candidateTuple[0] === existingTuple[0] && candidateTuple[1] === existingTuple[1] && candidateTuple[2] > existingTuple[2])
            ) {
                latestByRepo.set(key, project);
            }
        }

        return [...passthrough, ...latestByRepo.values()];
    }

    function renderButton(href, label) {
        return `<a class="button" href="${href}">${label}</a>`;
    }

    function escapeHtml(value) {
        return String(value)
            .replaceAll("&", "&amp;")
            .replaceAll("<", "&lt;")
            .replaceAll(">", "&gt;")
            .replaceAll('"', "&quot;");
    }

    function sourceComparison(project, observation) {
        if (!observation || observation.state === "not_observed") return "No public repository observation";
        if (observation.state === "check_failed") return "Check failed; previous observation retained";
        if (project.source_dirty) return "Export included uncommitted changes; review source";
        if (project.source_commit && observation.snapshot_commit !== project.source_commit) return "New snapshot; repository comparison pending";
        const labels = {
            matches: "Matches exported source", different_commit: "Different source commit; review export",
            content_matches: "Archive content matches snapshot", content_changed: "Archive content changed; review snapshot",
            dirty_snapshot: "Export included uncommitted changes", newer_commit: "Newer than reported snapshot",
            legacy_unverified: "Commit identity unavailable", awaiting_export: "Awaiting first published export",
            awaiting_deployment: "Awaiting first deployment",
        };
        const stale = Date.now() - Date.parse(observation.checked_at) > 8 * 86400000;
        return (labels[observation.state] || "Comparison unavailable") + (stale ? " (check over eight days old)" : "");
    }

    function renderProjectCard(project, observation) {
        const description = project.description || "Public project page synced from its repository status manifest.";
        const buttons = [
            renderButton(escapeHtml(project.project_page_href), "Open project page"),
        ];

        if (project.dashboard_url) {
            buttons.push(renderButton(escapeHtml(project.dashboard_url), "Open dashboard"));
        }
        if (project.experience_url) {
            buttons.push(renderButton(escapeHtml(project.experience_url), "Open live experience"));
        }
        if (project.repo_url) {
            buttons.push(renderButton(escapeHtml(project.repo_url), "Open repository"));
        }

        let details = [
            `<div><strong>${project.source_commit ? "Snapshot source date" : "Reported snapshot date"}</strong> ${project.repo_pushed_at ? escapeHtml(formatLocalDate(project.repo_pushed_at)) : "Not reported"}</div>`,
            `<div><strong>Status exported</strong> ${escapeHtml(formatLocalDateTime(project.status_generated_at))}</div>`,
            `<div><strong>Repository checked</strong> ${observation?.checked_at ? escapeHtml(formatLocalDateTime(observation.checked_at)) : "Not observed"}</div>`,
            `<div><strong>Source comparison</strong> ${escapeHtml(sourceComparison(project, observation))}</div>`,
            project.timeline_label ? `<div><strong>Archive span</strong> ${escapeHtml(project.timeline_label)}</div>` : "",
            `<div><strong>${escapeHtml(project.status_label)}</strong> ${escapeHtml(project.status_value)}</div>`,
            `<div><strong>${escapeHtml(project.focus_label)}</strong> ${escapeHtml(project.focus_value)}</div>`,
        ].filter(Boolean);
        if (project.private_metadata) {
            details = privateDetails(project.private_metadata).map(([label, value]) =>
                `<div><strong>${escapeHtml(label)}</strong> ${escapeHtml(value)}</div>`
            ).concat([details[1], ...details.slice(-2)]);
        }

        const personContext = project.person_context
            ? `<p class="footer">${escapeHtml(project.person_context)}</p>`
            : "";

        return `                <article class="card" data-project-card="${escapeHtml(project.project_id)}">
                    <h3>${escapeHtml(project.display_name)}</h3>
                    <p>${escapeHtml(description)}</p>
                    <div class="detailList">
                        ${details.join("")}
                    </div>
                    ${personContext}
                    <div class="links">
                        ${buttons.join(" ")}
                    </div>
                </article>`;
    }

    function privateDetails(metadata) {
        const date = (value) => value ? formatLocalDateTime(value) : "Not reported";
        const activity = metadata.activity;
        return [
            ["Visibility", "Private code and data; approved summary only"],
            ["Metadata checked", date(metadata.checked_at)],
            ["Metadata freshness", Date.now() - Date.parse(metadata.checked_at) > 8 * 86400000 ? "Report over eight days old; review needed" : "Recorded metadata check; not a live repository check"],
            ["Report basis", metadata.report_basis],
            ["Default-branch commit date", date(metadata.last_default_branch_commit_at)],
            ["Release", metadata.release_version ? `${metadata.release_version}; ${date(metadata.released_at)}` : "Not verified; no release claimed"],
            ["Reported default-branch activity", activity ? `${activity.commit_count} commits; ${date(activity.window_start)} to ${date(activity.window_end)}` : "Not reported (not zero)"],
            ["Activity scope", "Fixed window; includes merges and all file types; excludes other branches and local edits"],
        ];
    }

    async function fetchManifestPayloads(urls) {
        const results = await Promise.all(
            urls.map(async (url) => {
                const response = await fetch(url, { cache: "no-store" });
                if (!response.ok) {
                    throw new Error(`Manifest fetch failed for ${url}`);
                }
                return response.json();
            })
        );

        return results.filter((payload) => payload && payload.active);
    }

    async function loadProjectManifests(config) {
        return fetchManifestPayloads([
            ...(config.fallback_manifest_paths || []),
            ...(config.supplemental_manifest_paths || []),
        ]);
    }

    async function initProjectManifestCards() {
        const panel = document.querySelector("[data-project-manifests]");
        const config = parseJsonScript("project-manifest-config");
        if (!panel || !config) {
            return;
        }

        const grid = panel.querySelector("[data-project-grid]");
        const countNode = document.querySelector("[data-project-count]");
        const lastUpdatedNode = document.querySelector("[data-project-last-updated]");
        const statusNode = panel.querySelector("[data-project-status]");

        if (statusNode) {
            statusNode.textContent = "Refreshing project cards from the latest published manifest files...";
        }

        try {
            const [payloads, response] = await Promise.all([
                loadProjectManifests(config), fetch("data/shared/repository-observations.json", { cache: "no-store" }),
            ]);
            if (!response.ok) throw new Error("Repository observations unavailable");
            const observations = (await response.json()).projects || {};
            const projects = dedupeProjects(payloads);
            projects.sort(projectSortFactory(config));

            if (grid) {
                grid.innerHTML = projects.map((project) => renderProjectCard(project, observations[project.project_id])).join("\n");
            }

            if (countNode) {
                countNode.textContent = String(projects.length);
            }

            const lastUpdated = projects.reduce((latest, project) => {
                if (!project.repo_pushed_at) return latest;
                const current = new Date(project.repo_pushed_at);
                return !latest || current > latest ? current : latest;
            }, null);

            if (lastUpdatedNode && lastUpdated) {
                lastUpdatedNode.textContent = formatLocalDate(lastUpdated.toISOString());
            }

            if (statusNode) {
                statusNode.textContent = "Project cards loaded from this published site. Source dates, export dates, and repository check times are independent.";
            }
        } catch (error) {
            if (statusNode) {
                statusNode.textContent = "Showing the rendered fallback cards because the published manifest refresh is unavailable right now.";
            }
        }
    }

    function niceUpperBound(value) {
        if (value <= 5) {
            return 5;
        }
        if (value <= 20) {
            return Math.ceil(value / 5) * 5;
        }
        if (value <= 60) {
            return Math.ceil(value / 10) * 10;
        }
        if (value <= 120) {
            return Math.ceil(value / 20) * 20;
        }
        return Math.ceil(value / 25) * 25;
    }

    function bucketCounts(commitDates, bucketStarts, bucketEnds) {
        const counts = new Array(bucketStarts.length).fill(0);
        for (const commitDate of commitDates) {
            const timestamp = commitDate.getTime();
            for (let index = 0; index < bucketStarts.length; index += 1) {
                if (timestamp >= bucketStarts[index].getTime() && timestamp < bucketEnds[index].getTime()) {
                    counts[index] += 1;
                    break;
                }
            }
        }
        return counts;
    }

    function countsForProject(project, row, bucketStarts, bucketEnds) {
        const unavailable = bucketStarts.map(() => null);
        if (!row || row.state !== "ok" || row.repo !== project.repo ||
            JSON.stringify(row.paths) !== JSON.stringify(project.paths) ||
            JSON.stringify(row.exclude_paths || []) !== JSON.stringify(project.exclude_paths || [])) return unavailable;
        const dates = new Map(row.commits.map((commit) => [commit.sha, new Date(commit.date)]));
        const counts = bucketCounts([...dates.values()], bucketStarts, bucketEnds);
        return counts.map((count, index) =>
            Date.parse(row.window_start) <= bucketStarts[index].getTime() && Date.parse(row.checked_at) >= bucketStarts[index].getTime()
                ? count : null);
    }

    function renderActivityData(chart, config, weeks, message) {
        const legendTotals = new Map(
            Array.from(chart.querySelectorAll("[data-activity-legend-total]")).map((node) => [
                node.getAttribute("data-activity-legend-total"),
                node,
            ])
        );
        const axisTop = chart.querySelector('[data-activity-axis="top"]');
        const axisMid = chart.querySelector('[data-activity-axis="mid"]');
        const refreshedNode = chart.querySelector("[data-activity-last-refreshed]");
        const statusNode = chart.querySelector("[data-activity-status]");
        const weekNodes = Array.from(chart.querySelectorAll("[data-activity-week]"));
        const projectLabels = new Map(config.projects.map((project) => [project.project_id, project.label]));
        const projectColors = new Map(config.projects.map((project) => [project.project_id, [project.color_top, project.color_bottom]]));

        const totalsByProject = new Map(config.projects.map((project) => [project.project_id, 0]));
        let maxTotal = 0;

        weeks.forEach((week) => {
            let total = 0;
            let incomplete = false;
            for (const project of config.projects) {
                const count = week.counts[project.project_id];
                const previous = totalsByProject.get(project.project_id);
                totalsByProject.set(project.project_id, previous === null || count === null ? null : previous + count);
                incomplete ||= count === null;
                total += count || 0;
            }
            maxTotal = Math.max(maxTotal, total);
            week.total = incomplete ? null : total;
        });

        const ceiling = niceUpperBound(maxTotal);
        if (axisTop) {
            axisTop.textContent = String(ceiling);
        }
        if (axisMid) {
            axisMid.textContent = String(Math.floor(ceiling / 2));
        }

        weekNodes.forEach((weekNode, index) => {
            const week = weeks[index];
            const totalNode = weekNode.querySelector("[data-activity-total]");
            if (totalNode) {
                totalNode.textContent = week.total === null ? "N/A" : String(week.total);
            }

            const stack = weekNode.querySelector(".activityStack");
            if (stack) {
                const labelNode = weekNode.querySelector(".activityLabel");
                const labelText = labelNode ? labelNode.textContent : `Week ${index + 1}`;
                stack.setAttribute("aria-label", `${labelText}: ${week.total === null ? "N/A" : week.total} total ${config.metric_label || "commits"}`);
            }

            const segmentNodes = Array.from(weekNode.querySelectorAll("[data-activity-project]"));
            for (const segmentNode of segmentNodes) {
                const projectId = segmentNode.getAttribute("data-activity-project");
                const count = week.counts[projectId];
                const height = ceiling > 0 ? ((count || 0) / ceiling) * 100 : 0;
                const colors = projectColors.get(projectId) || ["rgba(121, 184, 255, 0.96)", "rgba(74, 126, 230, 0.96)"];
                segmentNode.style.height = `${height.toFixed(2)}%`;
                segmentNode.style.setProperty("--activity-top", colors[0]);
                segmentNode.style.setProperty("--activity-bottom", colors[1]);
                segmentNode.title = `${projectLabels.get(projectId) || projectId}: ${count === null ? "Unavailable" : count} ${config.metric_label || "commits"}`;
            }
        });

        for (const [projectId, node] of legendTotals.entries()) {
            const total = totalsByProject.get(projectId);
            node.textContent = total === null ? "Unavailable" : String(total);
        }

        if (statusNode) {
            statusNode.textContent = message;
        }
        if (refreshedNode) {
            refreshedNode.textContent = config.checked_at ? formatLocalDateTime(config.checked_at) : "Not yet measured";
        }
    }

    async function initActivityChart(chart) {
        const chartId = chart.getAttribute("data-activity-chart-id");
        const config = parseJsonScript(`activity-chart-config-${chartId}`);
        if (!chart || !config) {
            return;
        }

        const bucketConfig = Array.isArray(config.buckets) ? config.buckets : [];
        const bucketStarts = bucketConfig.map((entry) => new Date(entry.start));
        const bucketEnds = bucketConfig.map((entry) => new Date(entry.end));
        const refreshedNode = chart.querySelector("[data-activity-last-refreshed]");
        const statusNode = chart.querySelector("[data-activity-status]");

        chart.style.setProperty("--activity-columns", String(bucketConfig.length || 8));

        const weekNodes = Array.from(chart.querySelectorAll("[data-activity-week]"));
        weekNodes.forEach((weekNode, index) => {
            const labelNode = weekNode.querySelector(".activityLabel");
            if (labelNode && bucketConfig[index]) {
                labelNode.textContent = bucketConfig[index].label;
            }
        });

        const computedBucketEnds = bucketEnds.length ? bucketEnds : bucketStarts.map((start, index) =>
            index < bucketStarts.length - 1 ? bucketStarts[index + 1] : new Date(start.getTime() + 7 * 24 * 60 * 60 * 1000)
        );

        if (refreshedNode && config.generated_at) {
            refreshedNode.textContent = formatLocalDateTime(config.generated_at);
        }

        if (statusNode) {
            statusNode.textContent = "Loading the published GitHub history snapshot...";
        }

        try {
            const snapshot = await loadActivitySnapshot();
            if (snapshot.date_basis !== "committer") throw new Error("Unknown history date basis");
            const countsByProject = config.projects.map((project) => countsForProject(
                project, snapshot.projects[project.project_id], bucketStarts, computedBucketEnds));
            const weeks = bucketStarts.map((start, index) => {
                const counts = {};
                config.projects.forEach((project, projectIndex) => {
                    counts[project.project_id] = countsByProject[projectIndex][index];
                });
                return {
                    start: start.toISOString(),
                    label: bucketConfig[index]?.label || `Bucket ${index + 1}`,
                    counts,
                };
            });

            const checks = config.projects.map((project) => snapshot.projects[project.project_id]?.checked_at).filter(Boolean).sort((a, b) => Date.parse(a) - Date.parse(b));
            config.checked_at = checks[0] || null;
            const missing = config.projects.filter((project, index) => countsByProject[index].includes(null)).map((project) => project.label);
            const stale = config.checked_at && Date.now() - Date.parse(config.checked_at) > 8 * 86400000;
            renderActivityData(chart, config, weeks,
                `Published public default-branch history, counted by committer date. Current periods are partial. Commits do not measure effort, quality, or releases.${missing.length ? ` Unavailable: ${missing.join(", ")}.` : ""}${stale ? " History check is over eight days old." : ""}`);
        } catch (error) {
            if (statusNode) {
                statusNode.textContent = "Could not reload published activity data; showing the rendered history snapshot with its recorded check time.";
            }
        }
    }

    let activitySnapshotPromise;
    function loadActivitySnapshot() {
        activitySnapshotPromise ||= fetch("data/shared/repository-activity.json", { cache: "no-store" }).then((response) => {
            if (!response.ok) throw new Error("Published activity unavailable");
            return response.json();
        });
        return activitySnapshotPromise;
    }

    if (typeof module !== "undefined") module.exports = { bucketCounts, countsForProject, dedupeProjects, projectSortFactory, sourceComparison, renderProjectCard, privateDetails };
    if (typeof document === "undefined") return;
    initProjectManifestCards();
    document.querySelectorAll("[data-activity-chart]").forEach((chart) => {
        initActivityChart(chart);
    });
})();
