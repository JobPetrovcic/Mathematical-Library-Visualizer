# import haskell
FROM haskell:9.4.5

CMD bash

RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ARG guest=VL
ARG guest_uid=1000
ARG guest_gid=${guest_uid}

# create a user
RUN groupadd -g ${guest_gid} ${guest} \
        && useradd --no-log-init -m -s /bin/bash -g ${guest} -G sudo -p '' -u ${guest_uid} ${guest} \
        && mkdir -p -v /home/${guest}/.local/bin \
        && chown -R ${guest}:${guest} /home/${guest} \
        && sed -i -e '/%sudo/s/)/) NOPASSWD:/' /etc/sudoers

WORKDIR /home/${guest}
USER ${guest}

# GHC
ARG GHC=9.4.5
ARG CABAL_INSTALL=3.2

ENV PATH /home/${guest}/.local/bin:/opt/cabal/${CABAL_INSTALL}/bin:/opt/ghc/${GHC}/bin:/usr/local/bin:/usr/bin:/bin
ENV LC_ALL=C.UTF-8

# setup agda
ADD agda_install.sh ./
RUN sudo chmod +x agda_install.sh
#RUN ./agda_install.sh

# setup python
ADD requirements.txt ./
RUN sudo apt-get install -y python3
RUN sudo apt-get -y install python3-pip
RUN pip install requirements.txt -r


# copy entrypoint
COPY entrypoint.sh /home/VL/entrypoint.sh
RUN sudo chmod +x /home/VL/entrypoint.sh

# run entrypoint
ENTRYPOINT [ "/home/VL/entrypoint.sh" ]