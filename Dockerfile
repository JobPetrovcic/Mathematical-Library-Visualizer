FROM ubuntu:22.04

CMD bash

ADD requirements.txt ./
RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y -q ghc ghc-prof ghc-doc \
		apt-get install -y -q git \
		apt-get update && apt-get install -y python3.10 \
		apt-get install -y -q python3-pip \
		pip install -r requirements.txt 


ENV LC_ALL=C.UTF-8
ENV ghc_version=9.0.2

# copy entrypoint
ADD entrypoint.sh /entrypoint.sh
ADD find_source.py /
ADD library_installs_sh /library_installs_sh

# INSTALL AGDA
RUN apt-get install -y curl \
	curl -sSL https://get.haskellstack.org/ | sh \
	stack --resolver ghc-${ghc_version} setup \
	mkdir -p ~/.agda \
	cd ~/.agda \
	git clone --depth 1 -b release-2.6.4.3-base https://github.com/JobPetrovcic/agda src \
	stack --stack-yaml src/stack-"${ghc_version}".yaml install \
	stack --stack-yaml src/stack-"${ghc_version}".yaml clean \
	sudo chmod +x /entrypoint.sh

# add agda to path
ENV PATH="~/.local/bin:$PATH"

# INSTALL LEAN
# first install build-deps from https://github.com/docker-library/buildpack-deps

#ARG DEBIAN_FRONTEND=noninteractive
#ENV TZ=Etc/UTC
#RUN set -eux; \
#	apt-get update; \
#	apt-get install -y --no-install-recommends \
#		ca-certificates \
#		curl \
#		gnupg \
#		netbase \
#		wget \
#		tzdata \
#	; \
#	rm -rf /var/lib/apt/lists/*
#
#RUN apt-get update && apt-get install -y --no-install-recommends \
#		git \
#		mercurial \
#		openssh-client \
#		subversion \
#		\
#		procps \
#	&& rm -rf /var/lib/apt/lists/*
#
#RUN set -ex; \
#	apt-get update; \
#	apt-get install -y --no-install-recommends \
#		autoconf \
#		automake \
#		bzip2 \
#		dpkg-dev \
#		file \
#		g++ \
#		gcc \
#		imagemagick \
#		libbz2-dev \
#		libc6-dev \
#		libcurl4-openssl-dev \
#		libdb-dev \
#		libevent-dev \
#		libffi-dev \
#		libgdbm-dev \
#		libglib2.0-dev \
#		libgmp-dev \
#		libjpeg-dev \
#		libkrb5-dev \
#		liblzma-dev \
#		libmagickcore-dev \
#		libmagickwand-dev \
#		libmaxminddb-dev \
#		libncurses5-dev \
#		libncursesw5-dev \
#		libpng-dev \
#		libpq-dev \
#		libreadline-dev \
#		libsqlite3-dev \
#		libssl-dev \
#		libtool \
#		libwebp-dev \
#		libxml2-dev \
#		libxslt-dev \
#		libyaml-dev \
#		make \
#		patch \
#		unzip \
#		xz-utils \
#		zlib1g-dev 
#ENV ELAN_HOME=/usr/local/elan \
#    PATH=/usr/local/elan/bin:$PATH \
#    LEAN_VERSION=leanprover/lean4:nightly
#
#RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y --no-modify-path --default-toolchain $LEAN_VERSION; \
#    chmod -R a+w $ELAN_HOME; \
#    elan --version; \
#    lean --version; \
#    leanc --version; \
#    lake --version;

# rm when testing on github
#RUN mkdir mockgitworkspace
#WORKDIR /mockgitworkspace
#ENV GITHUB_WORKSPACE=/mockgitworkspace
#RUN git clone https://github.com/algebraic-graphs/agda
#RUN mv agda mylib
#RUN mkdir agda-proof-assistent-assistent
#ADD agda-proof-assistent-assistent agda-proof-assistent-assistent


# run entrypoint
ENTRYPOINT ["/entrypoint.sh"]