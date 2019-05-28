#Todo
# Use fetcher image to get templates from github
# By doing so se REPO URL in "boilr templae list" will be correct

FROM alpine:3.9 as fetcher

ENV BOILR_VERSION 0.4.5

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3018,DL3016
RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && curl -SL https://github.com/Ilyes512/boilr/releases/download/${BOILR_VERSION}/boilr_${BOILR_VERSION}_Linux_64-bit.tar.gz \
    | tar xvz -C /opt \
    && apk del .build-deps

FROM alpine:3.9

LABEL maintainer "Sven <sven@testthedocs.org>" \
    org.label-schema.vendor = "TestTheDocs"

WORKDIR /srv

COPY --from=fetcher /opt/boilr /usr/local/bin/boilr
#COPY entrypoint.sh /usr/local/bin/entrypoint.sh
# hadolint ignore=DL3018,DL3016
RUN adduser -s /bin/false -D ttd \
        && apk add --no-cache \
	    bash \
            tini \
            su-exec \
            libc6-compat \
            ca-certificates

USER ttd

RUN boilr template download okular-d/doozer-project new-project
#CMD ["boilr"]
#ENTRYPOINT [ "/sbin/tini", "--", "/usr/local/bin/entrypoint.sh" ]

# Syntax to run (tmp)
# docker run --rm -it -v `pwd`:/srv mbm template use style .
