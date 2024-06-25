FROM alpine:3.7
MAINTAINER Jason <jason@gymoo.cn>

ENV NODE_VERSION 16.14.0
ENV YARN_VERSION 1.3.2

# Install necessary dependencies
RUN apk add --no-cache \
    libstdc++ \
    curl \
    tar \
    xz \
    && apk add --no-cache --virtual .build-deps \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        make \
        python3

# Download and install Node.js
RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.xz" \
    && tar -xf "node-v$NODE_VERSION-linux-x64.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && apk del .build-deps \
    && rm "node-v$NODE_VERSION-linux-x64.tar.xz"

# Download and install Yarn
RUN curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
    && mkdir -p /opt/yarn \
    && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
    && rm yarn-v$YARN_VERSION.tar.gz

WORKDIR /app

COPY . .

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
