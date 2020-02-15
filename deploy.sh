#!/usr/bin/env bash

# Define some constants to simplify the script
DOCKER_IMAGE_NAME="kubehello"
DOCKER_BUILD_DIRECTORY="target"

function check_kube {
  echo "Checking the status of your minikube"
  minikube status
  kube_code=$?
  if [ $kube_code -gt 0 ]
  then
    echo "Minikube is not running. Please start before continuing"
    exit 10
  fi
}

function python_build {
  python setup.py test sdist
  build_code=$?
  if [ $build_code -ne 0 ]
  then
    exit 20
  fi
}

function docker_build {
  mkdir -p ${DOCKER_BUILD_DIRECTORY}
  # Add the docker components to the working directory
  cp dist/kubehello* ${DOCKER_BUILD_DIRECTORY}/kubehello.tar.gz
  cp docker/Dockerfile ${DOCKER_BUILD_DIRECTORY}
  
  docker build -t ${DOCKER_IMAGE_NAME}:latest ${DOCKER_BUILD_DIRECTORY}
}

function deploy_k8s {
  kubectl create -f ./k8s/deployment.yml
  if [ $? -ne 0 ]
  then
    exit 30
  fi

  kubectl create -f ./k8s/service.yml
  if [ $? -ne 0 ]
  then
    exit 40
  fi

  echo "Awaiting pod startup..."
  kubectl get po
  if [ $? -ne 0 ]
  then
    exit 50
  fi
}

function cleanup {
  # Finally remove the working directory
  rm -r ${DOCKER_BUILD_DIRECTORY}
}

check_kube
python_build
docker_build
deploy_k8s
cleanup