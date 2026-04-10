# syntax=docker/dockerfile:1.2

ARG NODE_VERSION=24.11.1

FROM node:${NODE_VERSION}-alpine AS builder

ARG VERSION=1.0.0
ENV APP_VERSION=$VERSION

WORKDIR /usr/src/app

RUN apk add --no-cache git openssh-client
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:Fkinf/tchlab6.git .
RUN npm install

RUN mkdir /output && node index.js

FROM nginx:alpine

RUN apk add --update curl && rm -rf /var/cache/apk/*

COPY --from=builder /output/index.html /usr/share/nginx/html/index.html

LABEL org.opencontainers.image.source="https://github.com/FKinf/tchlab6"
LABEL org.opencontainers.image.description="TCh Lab6 - Nginx app"
LABEL org.opencontainers.image.authors="FKinf"

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]