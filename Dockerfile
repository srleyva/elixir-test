FROM elixir:1.8-alpine as build

COPY rel ./rel

COPY config ./config

COPY lib ./lib

COPY deps ./deps

COPY mix.exs .

COPY mix.lock .

RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix release

RUN APP_NAME="minimal_server" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

FROM erlang:21.3-alpine

COPY --from=build /export/ .

RUN  apk upgrade --update-cache --available && \
    apk add openssl bash && \
    rm -rf /var/cache/apk/*

ENTRYPOINT [ "/bin/sh" ]
ENTRYPOINT ["minimal_server"]
CMD ["foreground"]
