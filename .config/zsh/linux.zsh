# Linux specific settings and aliases

## uv (standalone installer) — puts uv/uvx on PATH.
## Guarded: the file is absent where uv came from a package manager.
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
