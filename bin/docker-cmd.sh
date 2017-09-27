#!/usr/bin/env sh
set -e
set -x

NODE_ENV="${NODE_ENV:-development}"
SCRIPT_HOME=`dirname $0`
PROJECT_HOME="${SCRIPT_HOME}/.."

# build the app
yarn run build

# copy the dist to nginx html dir
cp -R "${PROJECT_HOME}/dist/*" /usr/share/nginx/html/

# update nginx default.conf
cp "${PROJECT_HOME}/config/nginx.default.conf" /etc/nginx/conf.d/default.conf

# start nginx
nginx -g 'daemon off;'
