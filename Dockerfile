FROM ubuntu:xenial

LABEL maintainer="DTI-SJC <tiusjc@gmail.com>"

ENV BOOTSTRAP_OPTS='-M'

ENV SALT_VERSION=stable

COPY bootstrap-salt.sh /tmp/

RUN sh /tmp/bootstrap-salt.sh -U -X -d $BOOTSTRAP_OPTS $SALT_VERSION && \
    apt-get clean

RUN /usr/sbin/update-rc.d -f ondemand remove; \
    update-rc.d salt-minion defaults && \
    update-rc.d salt-master defaults || true
RUN mkdir /srv/salt

VOLUME /etc/salt

VOLUME /srv/salt

ENTRYPOINT ["/usr/bin/salt-master"]

EXPOSE 4505 4506
