FROM ubuntu:22.04

CMD bash

RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y -q ghc ghc-prof ghc-doc

# setup python
ADD requirements.txt ./
RUN apt-get update && apt-get install -y python3.10
RUN apt-get install -y -q python3-pip
RUN pip install -r requirements.txt

# user settings
ARG guest=VL
ARG guest_uid=1000
ARG guest_gid=${guest_uid}

# create a user
#RUN groupadd -g ${guest_gid} ${guest} \
#        && useradd --no-log-init -m -s /bin/bash -g ${guest} -G sudo -p '' -u ${guest_uid} ${guest} \
#        && mkdir -p -v /home/${guest}/.local/bin \
#        && chown -R ${guest}:${guest} /home/${guest} \
#        && sed -i -e '/%sudo/s/)/) NOPASSWD:/' /etc/sudoers
#
#WORKDIR /home/${guest}
#USER ${guest}
#
## GHC
#ARG GHC=9.4.5
#ARG CABAL_INSTALL=3.2
#
#ENV PATH /home/${guest}/.local/bin:/opt/cabal/${CABAL_INSTALL}/bin:/opt/ghc/${GHC}/bin:/usr/local/bin:/usr/bin:/bin
ENV LC_ALL=C.UTF-8

# setup agda
ENV LC_ALL=C.UTF-8
RUN apt-get install -y curl
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack config set system-ghc --global true
RUN stack config set install-ghc --global false

RUN mkdir -p ~/.agda
RUN cd ~/.agda
RUN git clone --depth 1 -b master-sexp https://github.com/AndrejBauer/agda.git src

ENV ghc_version=8.8.4
RUN stack --stack-yaml src/stack-"${ghc_version}".yaml install
RUN stack --stack-yaml src/stack-"${ghc_version}".yaml clean

RUN agda-mode compile
#
# copy entrypoint
COPY entrypoint.sh /home/VL/entrypoint.sh
RUN sudo chmod +x /home/VL/entrypoint.sh

# run entrypoint
ENTRYPOINT [ "/home/VL/entrypoint.sh" ]