# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG SRCARCH
ARG VERSION
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        ca-certificates \
        curl \
        gcompat \
        git \
        libstdc++ \
        py-pygments \
    && curl -jSLN \
        -o /tmp/hugo.tar.gz \
        https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_${SRCARCH}.tar.gz \
    && tar xzf /tmp/hugo.tar.gz -C /usr/local/bin/ \
	&& apk del --purge curl \
    && rm -rf /var/cache/apk/* /tmp/*
#
VOLUME /home/alpine/project
# WORKDIR /home/alpine/project
#
EXPOSE 1313
#
HEALTHCHECK \
    --interval=2m \
    --retries=5 \
    --start-period=5m \
    --timeout=10s \
    CMD wget -q -T '2' -O /dev/null ${HEALTHCHECK_URL:-"http://localhost:1313/"} || exit 1
#
ENTRYPOINT ["/usershell"]
CMD ["hugo", "version"]
