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

    function nextLink(linkHeader) {
        if (!linkHeader) {
            return null;
        }

        for (const part of linkHeader.split(",")) {
            const match = part.match(/<([^>]+)>;\s*rel="next"/);
            if (match) {
                return match[1];
            }
        }

        return null;
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

    function dedupeProjects(projects) {
        const latestByRepo = new Map();
        const passthrough = [];

        for (const project of projects) {
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

    function renderProjectCard(project, config) {
        const description = project.description || "Public project page synced from its repository status manifest.";
        const buttons = [
            renderButton(escapeHtml(project.project_page_path), "Open project page"),
        ];

        if (project.dashboard_url) {
            buttons.push(renderButton(escapeHtml(project.dashboard_url), "Open dashboard"));
        }
        if (project.experience_url) {
            buttons.push(renderButton(escapeHtml(project.experience_url), "Open live experience"));
        }
        buttons.push(renderButton(escapeHtml(project.repo_url), "Open repository"));

        return `                <article class="card" data-project-card="${escapeHtml(project.project_id)}">
                    <h3>${escapeHtml(project.display_name)}</h3>
                    <p>${escapeHtml(description)}</p>
                    <div class="detailList">
                        <div><strong>Last repo update</strong> ${escapeHtml(formatLocalDate(project.repo_pushed_at))}</div>
                        <div><strong>${escapeHtml(project.status_label)}</strong> ${escapeHtml(project.status_value)}</div>
                        <div><strong>${escapeHtml(project.focus_label)}</strong> ${escapeHtml(project.focus_value)}</div>
                    </div>
                    <div class="links">
                        ${buttons.join(" ")}
                    </div>
                </article>`;
    }

    async function fetchManifestList(config) {
        const response = await fetch(config.repo_contents_api, {
            headers: {
                Accept: "application/vnd.github+json",
            },
        });
        if (!response.ok) {
            throw new Error(`GitHub API returned ${response.status}`);
        }

        const payload = await response.json();
        return payload
            .filter((item) => item && item.type === "file" && item.name && item.name.endsWith(".json"))
            .map((item) => item.download_url)
            .filter(Boolean);
    }

    async function fetchManifestPayloads(urls) {
        const results = await Promise.all(
            urls.map(async (url) => {
                const response = await fetch(url);
                if (!response.ok) {
                    throw new Error(`Manifest fetch failed for ${url}`);
                }
                return response.json();
            })
        );

        return results.filter((payload) => payload && payload.active);
    }

    async function loadProjectManifests(config) {
        try {
            const manifestUrls = await fetchManifestList(config);
            return await fetchManifestPayloads(manifestUrls);
        } catch (error) {
            const fallbackUrls = (config.fallback_manifest_paths || []).map((path) => path);
            return fetchManifestPayloads(fallbackUrls);
        }
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
            const projects = dedupeProjects(await loadProjectManifests(config));
            projects.sort(projectSortFactory(config));

            if (grid) {
                grid.innerHTML = projects.map((project) => renderProjectCard(project, config)).join("\n");
            }

            if (countNode) {
                countNode.textContent = String(projects.length);
            }

            const lastUpdated = projects.reduce((latest, project) => {
                const current = new Date(project.repo_pushed_at);
                return !latest || current > latest ? current : latest;
            }, null);

            if (lastUpdatedNode && lastUpdated) {
                lastUpdatedNode.textContent = formatLocalDate(lastUpdated.toISOString());
            }

            if (statusNode) {
                statusNode.textContent = `Project cards refreshed from published manifest files on ${formatLocalDateTime(new Date().toISOString())}.`;
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

    function bucketCounts(commitDates, weekStarts, weekEnds) {
        const counts = new Array(weekStarts.length).fill(0);
        for (const commitDate of commitDates) {
            const timestamp = commitDate.getTime();
            for (let index = 0; index < weekStarts.length; index += 1) {
                if (timestamp >= weekStarts[index].getTime() && timestamp < weekEnds[index].getTime()) {
                    counts[index] += 1;
                    break;
                }
            }
        }
        return counts;
    }

    async function fetchProjectCounts(project, sinceIso, weekStarts, weekEnds) {
        const commitDates = [];
        let url = `https://api.github.com/repos/sgwoods/${project.repo}/commits?sha=${encodeURIComponent(project.ref)}&since=${encodeURIComponent(sinceIso)}&per_page=100`;

        while (url) {
            const response = await fetch(url, {
                headers: {
                    Accept: "application/vnd.github+json",
                },
            });
            if (!response.ok) {
                throw new Error(`GitHub API returned ${response.status} for ${project.repo}`);
            }
            const payload = await response.json();
            for (const commit of payload) {
                const authoredAt = commit?.commit?.author?.date;
                if (authoredAt) {
                    commitDates.push(new Date(authoredAt));
                }
            }
            url = nextLink(response.headers.get("link"));
        }

        return bucketCounts(commitDates, weekStarts, weekEnds);
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
        const statusNode = chart.querySelector("[data-activity-status]");
        const weekNodes = Array.from(chart.querySelectorAll("[data-activity-week]"));
        const projectLabels = new Map(config.projects.map((project) => [project.project_id, project.label]));

        const totalsByProject = new Map(config.projects.map((project) => [project.project_id, 0]));
        let maxTotal = 0;

        weeks.forEach((week) => {
            let total = 0;
            for (const project of config.projects) {
                const count = week.counts[project.project_id] || 0;
                totalsByProject.set(project.project_id, totalsByProject.get(project.project_id) + count);
                total += count;
            }
            maxTotal = Math.max(maxTotal, total);
            week.total = total;
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
                totalNode.textContent = String(week.total);
            }

            const stack = weekNode.querySelector(".activityStack");
            if (stack) {
                const labelNode = weekNode.querySelector(".activityLabel");
                const labelText = labelNode ? labelNode.textContent : `Week ${index + 1}`;
                stack.setAttribute("aria-label", `${labelText}: ${week.total} total commits`);
            }

            const segmentNodes = Array.from(weekNode.querySelectorAll("[data-activity-project]"));
            for (const segmentNode of segmentNodes) {
                const projectId = segmentNode.getAttribute("data-activity-project");
                const count = week.counts[projectId] || 0;
                const height = ceiling > 0 ? (count / ceiling) * 100 : 0;
                segmentNode.style.height = `${height.toFixed(2)}%`;
                segmentNode.title = `${projectLabels.get(projectId) || projectId}: ${count} commits`;
            }
        });

        for (const [projectId, node] of legendTotals.entries()) {
            node.textContent = String(totalsByProject.get(projectId) || 0);
        }

        if (statusNode) {
            statusNode.textContent = message;
        }
    }

    async function initActivityChart() {
        const chart = document.querySelector("[data-activity-chart]");
        const config = parseJsonScript("activity-chart-config");
        if (!chart || !config) {
            return;
        }

        const weekStarts = config.weeks.map((value) => new Date(value));
        const weekEnds = weekStarts.map((start, index) =>
            index < weekStarts.length - 1 ? weekStarts[index + 1] : new Date(start.getTime() + 7 * 24 * 60 * 60 * 1000)
        );
        const sinceIso = weekStarts[0].toISOString();
        const statusNode = chart.querySelector("[data-activity-status]");

        if (statusNode) {
            statusNode.textContent = "Refreshing recent GitHub commit activity for Abtweak, CSP, and Galaga...";
        }

        try {
            const countsByProject = await Promise.all(
                config.projects.map((project) => fetchProjectCounts(project, sinceIso, weekStarts, weekEnds))
            );
            const weeks = weekStarts.map((start, index) => {
                const counts = {};
                config.projects.forEach((project, projectIndex) => {
                    counts[project.project_id] = countsByProject[projectIndex][index] || 0;
                });
                return {
                    start: start.toISOString(),
                    counts,
                };
            });

            renderActivityData(chart, config, weeks, `Updated from live GitHub commit history on ${formatLocalDateTime(new Date().toISOString())}.`);
        } catch (error) {
            if (statusNode) {
                statusNode.textContent = "Showing the local fallback chart because live GitHub stats are unavailable right now.";
            }
        }
    }

    initProjectManifestCards();
    initActivityChart();
})();
