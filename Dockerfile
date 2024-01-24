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

########## user settings
##########ARG guest=VL
##########ARG guest_uid=1000
##########ARG guest_gid=${guest_uid}
#########
########## create a user
##########RUN groupadd -g ${guest_gid} ${guest} \
##########        && useradd --no-log-init -m -s /bin/bash -g ${guest} -G sudo -p '' -u ${guest_uid} ${guest} \
##########        && mkdir -p -v /home/${guest}/.local/bin \
##########        && chown -R ${guest}:${guest} /home/${guest} \
##########        && sed -i -e '/%sudo/s/)/) NOPASSWD:/' /etc/sudoers
##########
##########WORKDIR /home/${guest}
##########USER ${guest}
##########
########### GHC
##########ARG GHC=9.4.5
##########ARG CABAL_INSTALL=3.2
##########
##########ENV PATH /home/${guest}/.local/bin:/opt/cabal/${CABAL_INSTALL}/bin:/opt/ghc/${GHC}/bin:/usr/local/bin:/usr/bin:/bin
ENV LC_ALL=C.UTF-8

# install curl
ENV LC_ALL=C.UTF-8
RUN apt-get install -y curl

# install stack
RUN curl -sSL https://get.haskellstack.org/ | sh
RUN stack config set system-ghc --global true
RUN stack config set install-ghc --global false

# clone hacked agda, VERSION: 2.6.3
RUN mkdir -p ~/.agda
RUN cd ~/.agda
RUN git clone --depth 1 -b release-2.6.3-sexp https://github.com/AndrejBauer/agda.git src

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
# first install build-deps from https://github.com/docker-library/buildpack-deps

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		gnupg \
		netbase \
		wget \
		tzdata \
	; \
	rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
		git \
		mercurial \
		openssh-client \
		subversion \
		\
		procps \
	&& rm -rf /var/lib/apt/lists/*

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		autoconf \
		automake \
		bzip2 \
		dpkg-dev \
		file \
		g++ \
		gcc \
		imagemagick \
		libbz2-dev \
		libc6-dev \
		libcurl4-openssl-dev \
		libdb-dev \
		libevent-dev \
		libffi-dev \
		libgdbm-dev \
		libglib2.0-dev \
		libgmp-dev \
		libjpeg-dev \
		libkrb5-dev \
		liblzma-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmaxminddb-dev \
		libncurses5-dev \
		libncursesw5-dev \
		libpng-dev \
		libpq-dev \
		libreadline-dev \
		libsqlite3-dev \
		libssl-dev \
		libtool \
		libwebp-dev \
		libxml2-dev \
		libxslt-dev \
		libyaml-dev \
		make \
		patch \
		unzip \
		xz-utils \
		zlib1g-dev 
ENV ELAN_HOME=/usr/local/elan \
    PATH=/usr/local/elan/bin:$PATH \
    LEAN_VERSION=leanprover/lean4:nightly

RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --no-modify-path --default-toolchain $LEAN_VERSION; \
    chmod -R a+w $ELAN_HOME; \
    elan --version; \
    lean --version; \
    leanc --version; \
    lake --version;

# rm when testing on github
#RUN mkdir mockgitworkspace
#WORKDIR /mockgitworkspace
#ENV GITHUB_WORKSPACE=/mockgitworkspace
#RUN git clone https://github.com/algebraic-graphs/agda
#RUN mv agda mylib
#RUN mkdir agda-proof-assistent-assistent
#ADD agda-proof-assistent-assistent agda-proof-assistent-assistent

# copy entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh
ADD find_source.py /
ADD library_installs_sh /library_installs_sh

# run entrypoint
ENTRYPOINT ["/entrypoint.sh"]