FROM quay.io/toolbx-images/debian-toolbox:13
LABEL maintainer="M. Edward (Ed) Borasky <znmeb@algocompsynth.com>"

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root
COPY installers/base-packages.sh installers/set-installer-envars /root/
RUN apt-get update -qq \
  && apt-get install -qqy \
    sudo \
    wget \
    > bootstrap.log 2>&1 \
  && ./base-packages.sh
