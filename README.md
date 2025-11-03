# Laravel Docker Project

Minimal Laravel environment fully containerized with Docker.

## Start

```bash
git clone <repo-url> new-project
cd new-project
docker compose up -d
docker compose exec -it nginx bash /app/setup.sh
```