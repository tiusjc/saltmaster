FROM debian:buster-slim 

LABEL maintainer DTI-SJC <tiusjc@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN groupadd -r docker && useradd -r -g docker saltdev

RUN apt-get update -q && apt-get install -q -y wget apt-utils nano gpg procps

RUN wget -O - 'https://repo.saltstack.com/py3/debian/10/amd64/latest/SALTSTACK-GPG-KEY.pub' | apt-key add -

RUN echo deb http://repo.saltstack.com/py3/debian/10/amd64/latest buster main > /etc/apt/sources.list.d/saltstack.list

RUN apt-get update && apt-get install -q -y salt-master salt-api curl

COPY autoaccept.conf /etc/salt/master.d/

COPY netapi.conf /etc/salt/master.d/

COPY entrypoint-master.sh /entrypoint-master.sh

RUN useradd saltdev -p '$6$0BIlOqYqg5Rcuu5A$ojdWZ.aZztdSqPCnqsEE3ViRDcFAZ0MSp0UUvT23GG5mnbUOcalZPh8basKox2wcn4F1if2kfChOO/J1K2boe.' && \
	  sed -i -e 's/^user: salt$/user: root/g' /etc/salt/master

RUN mkdir /srv/salt/

VOLUME /srv/salt/

VOLUME /etc/salt/master.d/

RUN export TERM=xterm

EXPOSE 4505/tcp

EXPOSE 4506/tcp

EXPOSE 8000/tcp

RUN /usr/sbin/update-rc.d -f ondemand remove; \
    update-rc.d salt-master defaults && \
    update-rc.d salt-api defaults || true

CMD /entrypoint-master.sh
