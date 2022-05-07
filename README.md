# CaRePi API

API of CaRePi

> CaRePi is **Ca**rd **Re**ader de **Pi** tte suru yatu

## spec

Rails 6.1.5.1  
Ruby 3.1.2

## setup

### 1. Configure [.env](/.env)

Tapyrus Auth Key, Slack Token and Slack Channel.

```
AUTH_KEY = 'cUJN5RVzYWFoeY8rUztd47jzXCu1p57Ay8V7pqCzsBD3PEXN7Dd4'
SLACK_API_TOKEN = 'xoxb-3467524078292-3456551248167-EERM5tlY8vL23GDdoEmAZMm8'
SLACK_CHANNEL = 'test'
```

### 2. Run via Docker Compose

```bash
$ docker-compose up -d
$ docker-compose exec rails ./bin/setup
```

## reset

```bash
$ docker-compose exec rails ./bin/rails db:migrate:reset
$ docker-compose exec rails ./bin/setup
```
