## Git Repositories

- `/home/spajxo/Projects/git.digital.cz` - GitLab (používej `glab` skill)
- `/home/spajxo/Projects/github.com` - GitHub (používej `gh`)

**GitLab MR:** Vždy `--assignee @me` a `--remove-source-branch`.

## DevProxy

Lokální HTTPS reverse proxy (nginx v Dockeru). Doména: `*.dsdev.digital` (wildcard DNS → 127.0.0.1, funguje i mezi kontejnery).

Docker Compose: `VIRTUAL_HOST`, `VIRTUAL_PORT`, network `proxy_network` (external).

Příkazy: `dsdev proxy start|stop|list|status|update|cert-install`

## Atlassian

- **Site:** digitalcz.atlassian.net
- **Cloud ID:** 6b2c79e1-f26a-48a5-9145-d9d5c553993e
