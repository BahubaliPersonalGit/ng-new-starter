FROM node:22-alpine AS dependencies

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

#-----------------------

FROM dependencies AS builder

COPY . .

RUN npm run build

RUN set -eux; \
    INDEX_FILE="$(find dist -type f -name index.html -print -quit)"; \
    test -n "${INDEX_FILE}"; \
    OUTPUT_DIR="$(dirname "${INDEX_FILE}")"; \
    mkdir -p /runtime; \
    cp -R "${OUTPUT_DIR}/." /runtime/

#-----------------------

FROM nginx:1.27-alpine AS runtime

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /runtime/ /usr/share/nginx/html/

RUN chown -R nginx:nginx \
    /usr/share/nginx/html \
    /var/cache/nginx \
    /var/run \
    /var/log/nginx

USER nginx

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --quiet --tries=1 --spider http://127.0.0.1:8080/ || exit 1