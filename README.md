This docker container allows to run android UI tests on self-hosted github runner.

## What this repository contains?
This repository contains:
* `Dockerfile` based on Ubuntu 20.04 LTS Focal Foss. During build process android sdk is installed and github action runner
* Simple `run_docker.sh` script which builds and runs container. Add required personal access token and repository owner/name. Edit for your needs
* `start.sh` bash script executed inside docker image when container starts to run. This script starts emulator and waits for boot process to be completed, diables animations, and starts github runner

Note: Personal Access Token should have `repo` scope granted in order to access given repository. Due to security reasons, using self-hosted in public repositories is not recommended.

## Usage
Simply run `run_docker.sh`. After build process has completed and github runner has started, runner should be visible in repositorie's `Settings/Actions/Runners`.

Note: Android emulator starts with `-accel on`, which assumes kvm VM acceleration. This requires host machine to have `/dev/kvm` available in order to work.


