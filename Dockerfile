FROM bitnami/minideb:latest

ARG INSTALL_URL="https://github.com/GuntharDeNiro/BTCT/releases/download/22/lin_v14.zip"
ARG DEBIAN_FRONTEND=noninteractive

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF org.label-schema.vcs-url="https://github.com/danialmoghaddam/docker-gunbot"

## Setup Enviroment
ENV TZ=Europe/Berlin \
  TERM=xterm-256color \
  FORCE_COLOR=true \
  NPM_CONFIG_COLOR=always \
  MOCHA_COLORS=true \
  INSTALL_URL=${INSTALL_URL}

## Setup pre-requisites
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && \
 apt-get install -y python && \
 apt-get install -y apt-utils


## Install additional libraries and upgrade
RUN apt-get -y upgrade && \
 apt-get install -y unzip curl fontconfig fonts-dejavu-extra && \
 apt-get clean -y && \
 apt-get autoclean -y && \
 apt-get autoremove -y

RUN fc-cache -fv

## Install Gunbot
WORKDIR /tmp
RUN curl -Lo /tmp/lin.zip ${INSTALL_URL}

RUN unzip -q lin.zip \
 && rm -rf lin.zip \
 && rm -rf __MACOSX \
 && mv lin* /gunbot \
 && rm -f /gunbot/config.js \
 && rm -f /gunbot/tgconfig.json \
 && rm -f /gunbot/autoconfig.json \
 && chmod +x /gunbot/gunthy-linux

WORKDIR /gunbot

EXPOSE 5000
VOLUME [ "/gunbot"]

CMD /gunbot/gunthy-linux