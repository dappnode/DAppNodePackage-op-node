ARG UPSTREAM_VERSION

FROM us-docker.pkg.dev/oplabs-tools-artifacts/images/op-node:${UPSTREAM_VERSION}

COPY /security /security
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]