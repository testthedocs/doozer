FROM node:12-alpine
LABEL maintainer="Sven <sven@testthedocs.org>" \
    org.label-schema.vendor="TestTheDocs"

# hadolint ignore=DL3018,DL3016
RUN apk add --no-cache \
        git \
        make \
        tini \
        su-exec \
    && npm install -g @fabiospampinato/template