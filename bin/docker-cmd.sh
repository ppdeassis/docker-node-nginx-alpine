#!/usr/bin/env sh
set -e
set -x

NODE_ENV="${NODE_ENV:-development}"

if [ $NODE_ENV == "development" ]; then
  # this runs webpack-dev-server with hot reloading
  yarn start
else
  # build the app
  yarn run build

  # copy the dist to nginx html dir
  cp -R ./dist /usr/share/nginx/html

  # update nginx.conf
  cp ./config/nginx.default.conf /etc/nginx/conf.d/default.conf

  # start nginx
  nginx -g 'daemon off;'
fi
