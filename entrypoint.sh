#!/bin/sh

set -e

# init nginx
if [ ! -d /run/nginx ]; then
    mkdir -p /run/nginx
    chown -R nginx.nginx /run/nginx
fi

docker ps

# init spug
cd /spug/spug_api
python3 -m venv venv
source venv/bin/activate
python manage.py updatedb
python manage.py user add -u admin -p spug.dev -s -n 管理员

nginx
supervisord -c /etc/supervisord.conf