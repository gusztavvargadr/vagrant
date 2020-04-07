FROM library/ubuntu:16.04
ARG VAGRANT_VERSION=2.2.7

WORKDIR /opt/gusztavvargadr/vagrant

RUN apt-get update -y
RUN apt-get install -y wget

RUN wget -q https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb
RUN dpkg -i vagrant_${VAGRANT_VERSION}_x86_64.deb

ENTRYPOINT [ "vagrant" ]
CMD [ "version" ]
