ARG BASE
FROM ${BASE}

WORKDIR /consul

ADD ./consul.hcl ./config/
RUN chown -R consul:consul ./config/*
RUN chmod -R o-rwx ./config/*
