#!/bin/bash

if [ -z  ${DOCKER_USERNAME} ]; then
   echo "missing DOCKER_USERNAME variable!"
   exit 1
fi

error() {
  if [ $? != 0 ]; then
    echo "error!"
    exit 122
  fi
}

gitbuild() {
  echo "Git building...${1}"
  git add .
  git commit -m ${2}
  git push origin master
}

dockerbuild() {
 echo "Docker building...${1}"
 docker build -t $(echo $DOCKER_USERNAME):${1} .
 echo "Built ${1}"
}

dockerpush() {
 echo "Docker pushing...${1}"
 docker push $(echo $DOCKER_USERNAME):${1}
 echo "Pushed $(echo $DOCKER_USERNAME):${1}"
}

gitbuild ${1} ${2}
error
dockerbuild ${1}
error
dockerpush ${1}
error

echo

exit 0
