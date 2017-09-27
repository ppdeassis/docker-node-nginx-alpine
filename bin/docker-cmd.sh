#!/usr/bin/env sh
set -e
set -x

NODE_ENV="${NODE_ENV:-development}"
SCRIPT_HOME=`dirname $0`

if [ $NODE_ENV == "development" ]; then
  # this runs webpack-dev-server with hot reloading
  yarn start
else
  # build the app
  yarn run build

  # copy the dist to nginx html dir
  cp -R "${SCRIPT_HOME}/dist/*" /usr/share/nginx/html/

  # update nginx default.conf
  cp "${SCRIPT_HOME}/config/nginx.default.conf" /etc/nginx/conf.d/default.conf

  # start nginx
  nginx -g 'daemon off;'
fi
