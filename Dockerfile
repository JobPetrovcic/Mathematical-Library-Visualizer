# Container image that runs your code
FROM haskell:9.6.2

# Copies your code file from your action repository to the filesystem path `/` of the container

COPY * /
RUN chmod +x /entrypoint.sh

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
