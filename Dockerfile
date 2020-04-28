FROM ubuntu:xenial

MAINTAINER DTI-SJC <tiusjc@gmail.com>

RUN apt-get update && apt-get install -q -y --no-install-recommends nano net-tools wget python-software-properties software-properties-common

RUN wget -O - https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -

RUN echo deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main > /etc/apt/sources.list.d/saltstack.list

RUN apt-get update && apt-get install -q -y salt-master

RUN export TERM=xterm

ENTRYPOINT ["/usr/bin/salt-master"]

EXPOSE 4505 4506
