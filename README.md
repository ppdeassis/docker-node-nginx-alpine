# docker-node-nginx-alpine
Dockerfile to build an image with Nginx and Node (npm and yarn) on Alpine Linux

Useful for deploying frontend services configurable by environment variables (_runtime_).

You can do something like:
```Dockerfile
FROM caiena/node-nginx-alpine

# lets install dependencies
WORKDIR /app
COPY . .
RUN rm -rf node_modules
RUN yarn install
RUN yarn cache clean

# starting: build the app (using env vars), update nginx conf and start nginx
CMD /bin/sh ./bin/docker-cmd.sh
```

Add a copy of [`bin/docker-cmd.sh`](bin/docker-cmd.sh) to your project and customize it.
And a copy of [`config/nginx.default.conf`](config/nginx.default.conf) and customize it too.

With this, you can configure something like `API_URL` as an environment variable - at service _runtime_ - making the images reusable with the tradeoff of being bigger (file size).

## Building the image
```bash
docker build --tag node-nginx-alpine .
```

## Running as a simple container
```bash
docker run -it --rm --publish 80:80 --name node-nginx-alpine node-nginx-alpine:latest
```


## Alternative
[Docker multi-stage builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds), which requires a new _build_ for every configuration (like `API_URL`).
Check this references for more details:
- https://docs.docker.com/engine/userguide/eng-image/multistage-build/#use-multi-stage-builds
- https://blog.alexellis.io/mutli-stage-docker-builds/
- https://github.com/docker/compose/issues/1837#issuecomment-316896858

A sample Dockerfile for multi-stage build:
```Dockerfile
# builder container
#   - builds the frontend app (Vue, React, Webpack, ...)

# Use an official node image
FROM node:8.5-alpine AS builder

# Reads args and use them to configure the build, setting
# them as env vars
ARG NODE_ENV
ARG API_URL

ENV NODE_ENV $NODE_ENV
ENV API_URL $API_URL

WORKDIR /app

# Install dependencies
COPY . .
RUN rm -rf node_modules
RUN yarn install
RUN yarn cache clean

RUN yarn run build


# ---


# runner container
#  - nginx, to serve static built Vue app

# Use an official nginx image
FROM nginx:1.13-alpine

# COPY dist from builder container to nginx html dir
COPY --from=builder /app/dist /usr/share/nginx/html

COPY config/nginx.default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# No need for CMD. It'll fallback to nginx image's one, which
```

You can build it with something like:
```bash
docker build --build-arg NODE_ENV=development --build-arg API_URL=https://api.example.com
```
