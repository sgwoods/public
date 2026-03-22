(() => {
    const chart = document.querySelector("[data-activity-chart]");
    const configNode = document.getElementById("activity-chart-config");
    if (!chart || !configNode) {
        return;
    }

    let config;
    try {
        config = JSON.parse(configNode.textContent);
    } catch (error) {
        return;
    }

    const weekNodes = Array.from(chart.querySelectorAll("[data-activity-week]"));
    const legendTotals = new Map(
        Array.from(chart.querySelectorAll("[data-activity-legend-total]")).map((node) => [
            node.getAttribute("data-activity-legend-total"),
            node,
        ])
    );
    const axisTop = chart.querySelector('[data-activity-axis="top"]');
    const axisMid = chart.querySelector('[data-activity-axis="mid"]');
    const statusNode = chart.querySelector("[data-activity-status]");

    const projectLabels = new Map(config.projects.map((project) => [project.project_id, project.label]));
    const weekStarts = config.weeks.map((value) => new Date(value));
    const weekEnds = weekStarts.map((start, index) =>
        index < weekStarts.length - 1 ? weekStarts[index + 1] : new Date(start.getTime() + 7 * 24 * 60 * 60 * 1000)
    );
    const sinceIso = weekStarts[0].toISOString();

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

    function nextLink(linkHeader) {
        if (!linkHeader) {
            return null;
        }
        const parts = linkHeader.split(",");
        for (const part of parts) {
            const match = part.match(/<([^>]+)>;\s*rel="next"/);
            if (match) {
                return match[1];
            }
        }
        return null;
    }

    function bucketCounts(commitDates) {
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

    async function fetchProjectCounts(project) {
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

        return bucketCounts(commitDates);
    }

    function renderData(weeks, message) {
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

    async function refresh() {
        if (statusNode) {
            statusNode.textContent = "Refreshing recent GitHub commit activity for Abtweak, CSP, and Galaga...";
        }

        try {
            const countsByProject = await Promise.all(config.projects.map((project) => fetchProjectCounts(project)));
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

            const refreshedAt = new Intl.DateTimeFormat("en-CA", {
                dateStyle: "long",
                timeStyle: "short",
                timeZone: "America/Toronto",
            }).format(new Date());

            renderData(weeks, `Updated from live GitHub commit history on ${refreshedAt}.`);
        } catch (error) {
            if (statusNode) {
                statusNode.textContent = "Showing the local fallback chart because live GitHub stats are unavailable right now.";
            }
        }
    }

    refresh();
})();
