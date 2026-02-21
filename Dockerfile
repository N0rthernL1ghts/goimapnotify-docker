ARG GOIMAPNOTIFY_VERSION=2.5.3

FROM golang:1.26-alpine AS builder

WORKDIR /app

ARG GOIMAPNOTIFY_VERSION


RUN set -eux \
    && apk add git make \
    && git clone https://github.com/shackra/goimapnotify.git --branch "${GOIMAPNOTIFY_VERSION}" --depth 1 -j "$(nproc)" \
    && cd goimapnotify \
    && make build



FROM scratch AS rootfs

COPY --chmod=0777 --from=builder ["/app/goimapnotify/goimapnotify", "/usr/local/bin/goimapnotify"]
COPY --chmod=0777 --from=builder ["/app/goimapnotify/LICENSE", "/usr/local/share/doc/goimapnotify/LICENSE"]
COPY --chmod=0777 ["./src/goimapnotify-entrypoint.sh", "/goimapnotify-entrypoint.sh"]
COPY --chmod=0777 --from=docker:29-cli ["/usr/local/bin/docker", "/usr/local/bin/docker"]



FROM alpine:latest

RUN set -eux \
    && apk add --no-cache bash ca-certificates \
    && mkdir -p /etc/goimapnotify \
    && addgroup -g 2375 -S docker

COPY --from=rootfs ["/", "/"]

ARG GOIMAPNOTIFY_VERSION
ENV GOIMAPNOTIFY_VERSION=${GOIMAPNOTIFY_VERSION}

ENTRYPOINT ["/goimapnotify-entrypoint.sh"]