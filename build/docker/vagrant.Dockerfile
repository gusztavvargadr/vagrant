FROM library/ubuntu:16.04

WORKDIR /opt/gusztavvargadr/vagrant

RUN apt-get update -y
RUN apt-get install -y wget

RUN wget -q https://releases.hashicorp.com/vagrant/2.2.6/vagrant_2.2.6_x86_64.deb
RUN dpkg -i vagrant_2.2.6_x86_64.deb

ENTRYPOINT [ "vagrant" ]
CMD [ "version" ]
