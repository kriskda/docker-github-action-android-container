#!/bin/bash

PERSONAL_ACCESS_TOKEN="ENTER_PERSONAL_ACCESS_TOKEN"
RUNNER_NAME="android-runner"
REPO_OWNER="repository_owner"
REPO_NAME="repository_name"
DOCKER_CONTAINER_NAME="android-container"

sudo docker build -t $DOCKER_CONTAINER_NAME .
sudo docker run -t \
				-e PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN \
				-e RUNNER_NAME=$RUNNER_NAME \
				-e REPO_OWNER=$REPO_OWNER \
				-e REPO_NAME=$REPO_NAME \
				--device=/dev/kvm --rm $DOCKER_CONTAINER_NAME bash -c "./start.sh" &

