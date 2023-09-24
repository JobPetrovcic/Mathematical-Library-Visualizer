# Container image that runs your code
FROM ubuntu:22.04

CMD bash

RUN apt-get update -q \
        && apt-get install -y -q --no-install-recommends procps less emacs-lucid sudo m4 opam \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

ARG guest=demo
ARG guest_uid=1000
ARG guest_gid=${guest_uid}

RUN groupadd -g ${guest_gid} ${guest} \
        && useradd --no-log-init -m -s /bin/bash -g ${guest} -G sudo -p '' -u ${guest_uid} ${guest} \
        && mkdir -p -v /home/${guest}/.local/bin \
        && chown -R ${guest}:${guest} /home/${guest} \
        && sed -i -e '/%sudo/s/)/) NOPASSWD:/' /etc/sudoers

WORKDIR /home/${guest}
USER ${guest}

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]