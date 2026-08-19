FROM docker.io/library/debian:trixie-backports
LABEL maintainer="M. Edward (Ed) Borasky <znmeb@algocompsynth.com>"

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
COPY installers/trixie-packages.sh installers/set-versions.sh /root/
RUN apt-get update -qq \
  && apt-get install -qqy \
    sudo \
    wget \
    > bootstrap.log 2>&1 \
  && ./trixie-packages.sh 
