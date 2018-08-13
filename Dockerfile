FROM lsiobase/ubuntu:xenial

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="BiohZn"

ARG SBNC_VER="1.3.9"
ARG DEBIAN_FRONTEND="noninteractive"

# install packages
RUN \
  apt-get update && \
  apt-get install -y \
    tcl8.5-dev \
    libcurl4-openssl-dev && \
  mkdir -p \
    /tmp/sbnc-source && \
  curl -o \
    /tmp/sbnc.tar.gz -L \
    "https://shroudbnc.info/files/sbnc/sbnc-${SBNC_VER}.tar.gz" && \
  tar xf /tmp/sbnc.tar.gz -C \
    /tmp/sbnc-source --strip-components=1 && \
  cd /tmp/sbnc-source && \
  ./configure --prefix=/app/sbnc && \
  make && \
  make install && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 9000
VOLUME /config