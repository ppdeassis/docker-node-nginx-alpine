# building version
```bash
# building latest
docker build . --tag node-nginx-alpine:latest

# specific version tag
TAG=0.2.0; docker build --tag node-nginx-alpine:$TAG

# marking latest as a specific version
TAG=0.2.0; docker tag node-nginx-alpine:latest node-nginx-alpine:$TAG

# pushing to your registry (latest)
docker tag node-nginx-alpine:latest ppdeassis/node-nginx-alpine:latest \
  && docker push ppdeassis/node-nginx-alpine:latest

# pushing a specific version
TAG=0.2.0; \
  docker tag node-nginx-alpine:latest node-nginx-alpine:$TAG \
  && docker tag node-nginx-alpine:$TAG ppdeassis/node-nginx-alpine:$TAG \
  && docker push ppdeassis/node-nginx-alpine:$TAG
