#!/bin/bash
set -e

rm -f /myapp/tmp/pids/server.pid
bundle exec whenever --update-crontab
cron -f &

exec "$@"
