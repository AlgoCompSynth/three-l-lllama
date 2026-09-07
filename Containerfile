FROM docker.io/library/debian:trixie-backports
LABEL maintainer="M. Edward (Ed) Borasky <znmeb@algocompsynth.com>"

ENV DEBIAN_FRONTEND=noninteractive
ENV ADMIN_HOME=/home/$ADMIN_USER

# some scripts won't work without 'sudo'
RUN apt-get update -qq \
  && apt-get install -qqy \
  sudo \
  > bootstrap.log 2>&1
RUN nvidia-smi || true

# create the admin user
RUN useradd \
  --comment "Admin User" \
  --home-dir $ADMIN_HOME \
  --groups adm,sudo \
  --create-home \
  --shell /bin/bash \
  --user-group \
  $ADMIN_USER

COPY --parents --chown=$ADMIN_USER:$ADMIN_USER installers $ADMIN_HOME/

WORKDIR $ADMIN_HOME/installers
RUN ./1-root-scripts.sh

RUN mkdir --parents /home/linuxbrew/.linuxbrew \
  && chown -R $ADMIN_USER:$ADMIN_USER /home/linuxbrew
USER $ADMIN_USER
RUN ./2-user-scripts.sh

WORKDIR $ADMIN_HOME
