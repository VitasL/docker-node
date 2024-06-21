FROM alpine:3.7
MAINTAINER Jason <jason@gymoo.cn>

ENV NODE_VERSION 16.14.0
ENV YARN_VERSION 1.3.2

# install node (without npm).
RUN apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        make \
        python3 \
        tar \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && apk del .build-deps \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz"

# install yarn.
RUN apk add --no-cache --virtual .build-deps-yarn \
        curl \
    && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && mkdir -p /opt/yarn \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz \
    && apk del .build-deps-yarn

WORKDIR /app

EXPOSE 80

CMD ["node", ".output/server/index.mjs"]
