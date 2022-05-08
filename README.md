# CaRePi API

API of CaRePi

> CaRePi is **Ca**rd **Re**ader de **Pi** tte suru yatu


> [**CaRePi**](https://github.com/shmn7iii/CaRePi):  
> Composer of each system.
>
> [**CaRePi_api**](https://github.com/shmn7iii/CaRePi_api):  
> API program. Handle entry/exit and manage tokens. Ruby on Rails, tapyrusd
>
> [**CaRePi_reader**](https://github.com/shmn7iii/CaRePi_reader):  
> Card reader program. Read student number from student card and send request to API. Pyton, PaSoRi.
>
> [**CaRePi_slack**](https://github.com/motoha0827/CaRePi_slack):  
> Slack BOT program. Recieve slash command, interact with API, send message to Slack. Python, Slack BOLT.


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
