ARG BASE
FROM ${BASE}

WORKDIR /consul
ADD ./*.hcl config/

ADD ./run.sh .

CMD [ "sh", "./run.sh" ]
