# Laravel Dockerized Starter

A minimal Laravel environment fully containerized with Docker, ready for development.

## Requirements
- Docker

## Quick Start

### Download the repository using `curl` or `git`:

Option 1. Download via `curl`:
```bash
curl -L -o laravel-docker-projec.zip https://github.com/artengin/laravel-docker-project/archive/refs/heads/main.zip &&
unzip laravel-docker-projec.zip &&
rm laravel-docker-projec.zip &&
cd laravel-docker-project-main
```

Option 2. Clone via `git`:
```bash
git clone git@github.com:artengin/laravel-docker-project.git NEW-PROJECT-NAME && cd NEW-PROJECT-NAME
```

### Setup and Initialize Project

Before running, make sure you don’t have other Docker containers running.

```bash
./setup.sh
```

### Laravel project is ready for development!