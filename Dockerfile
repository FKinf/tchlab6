# syntax=docker/dockerfile:1

ARG NODE_VERSION=24.11.1

FROM node:${NODE_VERSION}-alpine AS builder

ARG VERSION=1.0.0
ENV APP_VERSION=$VERSION

WORKDIR /usr/src/app

COPY package.json ./
RUN npm install

COPY index.js ./

RUN mkdir /output && node index.js

FROM nginx:alpine

RUN apk add --update curl && rm -rf /var/cache/apk/*

COPY --from=builder /output/index.html /usr/share/nginx/html/index.html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl -f http://localhost/ || exit 1

CMD ["nginx", "-g", "daemon off;"]