# Laravel Docker Project

Minimal Laravel environment fully containerized with Docker.

## Start

```bash
# Clone the repository and enter the folder
git clone git@github.com:artengin/laravel-docker-project.git NEW-PROJECT-NAME && cd NEW-PROJECT-NAME

# Setup Git remote
./setup-git-remote.sh

# Start Docker containers
docker compose up -d

# Run app setup
docker compose exec -it nginx bash /app/setup.sh
```

#### Project is ready for development!