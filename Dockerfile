FROM alpine:3.16 AS builder
RUN apk add --no-cache \
      libffi-dev \
      ncurses-dev \
      alpine-sdk \
      musl-dev \
      zlib-dev \
      ghc \
      cabal
COPY rootfs/root/.cabal/config /root/.cabal/config
RUN set -ex; \
    mkdir -p /opt/agda; \
    cabal update; \
    cabal install \
      alex \
      happy \
      Agda-2.6.2.2 \
    ;

ENV PATH=/opt/agda/bin:$PATH
# Install standard-library and cubical
RUN set -ex; \
    git clone --depth 1 --branch v1.7.1 https://github.com/agda/agda-stdlib.git /opt/agda/agda-stdlib; \
    cd /opt/agda/agda-stdlib; \
    cabal install; \
# Type check all files in standard-library so that it doesn't need to be checked on every user submission.
    dist/build/GenerateEverything/GenerateEverything; \
    agda -i. -isrc Everything.agda; \
    git clone --depth 1 --branch v0.3 https://github.com/agda/cubical /opt/agda/cubical; \
    cd /opt/agda/cubical; \
    make;

FROM alpine:3.16
RUN apk add --no-cache \
      libffi \
      ncurses \
      gmp-dev \
    ;
COPY --from=builder /opt/agda/bin/agda /opt/agda/bin/agda
COPY --from=builder /opt/agda/share /opt/agda/share
COPY --from=builder /opt/agda/agda-stdlib /opt/agda/agda-stdlib
COPY --from=builder /opt/agda/cubical /opt/agda/cubical

RUN set -ex; \
    adduser -D codewarrior; \
    mkdir /workspace; \
    chown -R codewarrior:codewarrior /workspace;

USER codewarrior
ENV USER=codewarrior HOME=/home/codewarrior PATH=/opt/agda/bin:$PATH

RUN set -ex; \
    mkdir -p /workspace/agda; \
    mkdir -p $HOME/.agda; \
    echo '/opt/agda/agda-stdlib/standard-library.agda-lib' > $HOME/.agda/libraries; \
    echo '/opt/agda/cubical/cubical.agda-lib' >> $HOME/.agda/libraries;
WORKDIR /workspace/agda
