"""Render an opted-in external project's small hub page from its manifest."""
import html


def render(payload):
    name = html.escape(payload["display_name"])
    repo = payload["repo_url"]
    links = [(payload["experience_url"], "Play the published build"), (repo, "Source repository"),
             (repo + "/blob/main/docs/ARCHITECTURE.md", "Current architecture and features"),
             (repo + "/blob/main/docs/ROADMAP.md", "Roadmap"),
             (payload["dashboard_url"], "Build and test history")]
    buttons = " ".join(f'<a class="button" href="{html.escape(url, quote=True)}">{label}</a>' for url, label in links)
    sha = payload["source_commit"]
    image = f"https://raw.githubusercontent.com/{repo.removeprefix('https://github.com/')}/{sha}/docs/media/arch-gameplay.gif"
    return f'''<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{name} | Steven Woods Projects</title><link rel="stylesheet" href="assets/public-site.css"></head>
<body><main class="shell">
<section class="hero"><span class="eyebrow">Public project</span><h1>{name}</h1>
<p>{html.escape(payload['description'])}</p><div class="links">{buttons}</div></section>
<section class="panel"><h2>Published build</h2>
<p><strong>{html.escape(payload['status_value'])}</strong> · Built {html.escape(payload['source_build_at'])}</p>
<p>{html.escape(payload['focus_value'])}</p>
<img src="{image}" alt="Star Swarm gameplay from the published source documentation" style="max-width:100%;height:auto" loading="lazy">
</section><section class="panel"><h2>Status and next steps</h2>
<p>The source repository owns the tested feature description and roadmap. This page follows the deployed build identity; newer development is tracked separately on the portfolio homepage.</p>
<div class="links"><a class="button" href="project-suite-overview.html#project-{payload['project_id']}">Portfolio priorities</a>
<a class="button" href="index.html#repository-activity">Repository activity</a>
<a class="button" href="PROJECT-STATUS-CONTRACT.md">Maintaining this status</a></div>
</section></main></body></html>
'''
