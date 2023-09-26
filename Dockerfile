FROM ubuntu:22.04

CMD bash

RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y -q ghc ghc-prof ghc-doc

# install python and requirements
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

# INSTALL AGDA
ENV LC_ALL=C.UTF-8
RUN apt-get install -y curl

# install stack
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack config set system-ghc --global true
RUN stack config set install-ghc --global false

# clone hacked agda
RUN mkdir -p ~/.agda
RUN cd ~/.agda
RUN git clone --depth 1 -b master-sexp https://github.com/AndrejBauer/agda.git src

# set ghc and install hacked agda
ENV ghc_version=8.8.4
RUN stack --stack-yaml src/stack-"${ghc_version}".yaml install
RUN stack --stack-yaml src/stack-"${ghc_version}".yaml clean

# we dont need this
#RUN stack --stack-yaml src/stack-"${ghc_version}".yaml install alex
#RUN stack --stack-yaml src/stack-"${ghc_version}".yaml install happy

# add agda to path
ENV PATH="~/.local/bin:$PATH"

# INSTALL LEAN
RUN wget -q https://raw.githubusercontent.com/leanprover-community/mathlib4/master/scripts/install_debian.sh && bash install_debian.sh 
RUN rm -f install_debian.sh && source ~/.profile

RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --no-modify-path --default-toolchain $LEAN_VERSION; \
#    chmod -R a+w $ELAN_HOME; \
#    elan --version; \
#    lean --version; \
#    leanc --version; \
#    lake --version; \

# copy entrypoint
COPY entrypoint.sh /home/VL/entrypoint.sh
RUN sudo chmod +x /home/VL/entrypoint.sh

# run entrypoint
#ENTRYPOINT [ "/home/VL/entrypoint.sh" ]