ARG BASE
FROM ${BASE}

WORKDIR /vault

ADD ./vault.hcl ./config/
RUN chown -R vault:vault ./config/
RUN chmod -R o-rwx ./config/
