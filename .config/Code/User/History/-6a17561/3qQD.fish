[open]
rules = [
    # 1. Hand-pick the "Tech" files you want in VS Code
    { url = "Dockerfile", use = "vscode" },
    { url = "docker-compose.yml", use = "vscode" },
    { url = "*.{sh,py,js,json,yaml,toml,conf,txt,md}", use = "vscode" },

    # 2. Catch any other text-based files
    { mime = "text/*", use = "vscode" }

    # 3. NOTICE: We removed the { url = "*" } rule!
    # This allows Yazi to fall back to the system default for photos/videos.
]

[opener]
vscode = [
    { run = 'code --wait "$@"', block = true, for = "unix" }
]