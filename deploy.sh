#!/usr/bin/env bash

# Define some constants to simplify the script
if [ $# -ge 1 ]
then
  DOCKER_NAMESPACE=$1
else
  echo "Enter dockerhub namespace"
  read DOCKER_NAMESPACE
fi

DOCKER_IMAGE_NAME="kubehello"
DOCKER_BUILD_DIRECTORY="target"
REQUIRED_PORT="8080"

imageName=${DOCKER_NAMESPACE}/${DOCKER_IMAGE_NAME}:latest

function check_kube {
  echo "Checking the status of your minikube"
  minikube status
  kube_code=$?
  if [ $kube_code -gt 0 ]
  then
    echo "Minikube is not running. Please start before continuing"
    exit 10
  fi

  #Make sure ingress is enabled
  minikube addons enable ingress
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

  echo "docker build -t ${imageName} ${DOCKER_BUILD_DIRECTORY}"
  docker build -t ${imageName} ${DOCKER_BUILD_DIRECTORY}

  docker push ${imageName}
}

function deploy_k8s {
  k8s_dir=${DOCKER_BUILD_DIRECTORY}/k8s
  mkdir -p ${k8s_dir}

  # Replace the image name and port so we can configure it on deploy
  sed -e "s|IMAGE_NAME_PLACEHOLDER|${imageName}|g" ./k8s/deployment.yml > ${k8s_dir}/tmp
  sed -e "s|PORT_PLACEHOLDER|${REQUIRED_PORT}|g" ${k8s_dir}/tmp > ${k8s_dir}/deployment.yml
  kubectl apply -f ${k8s_dir}/deployment.yml
  if [ $? -ne 0 ]
  then
    exit 30
  fi

  # Again update the port
  sed -e "s|PORT_PLACEHOLDER|${REQUIRED_PORT}|g" ./k8s/service.yml > ${k8s_dir}/service.yml
  kubectl apply -f ${k8s_dir}/service.yml
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

function start_app {
  echo Sleeping to enable the system to start up
  sleep 30
  minikube service hello-deployment
}

check_kube
python_build
docker_build
deploy_k8s
cleanup