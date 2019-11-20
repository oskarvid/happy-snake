#!/usr/bin/env bash

# This script documents how to build the singularity container
# from the Dockerfile


# exit on errors
trap 'clean' ERR

# stop and remove registry server
clean () {
	docker container stop registry
	docker container rm registry
	docker rmi localhost:5000/happy-snake
	exit
}

# docker registry server to host docker image locally
# do nothing if running, otherwise try to start registry or create registry
[[ "$(docker inspect -f '{{.State.Running}}' registry)" == "true" ]] \
  || docker container start registry \
  || docker run -d -p 5000:5000 --restart=always --name registry registry:2

# push image to local registry
docker tag oskarv/happy-snake localhost:5000/happy-snake
docker push localhost:5000/happy-snake

# create a temporary singularity def file
declare -r TMPFILE="$(mktemp --suffix 'singularity.def')"
cat > "$TMPFILE" << EOI
Bootstrap: docker
Registry: http://localhost:5000
Namespace:
From: happy-snake:latest
EOI

# build singularity image 
sudo SINGULARITY_NOHTTPS=1 singularity build singularity/happy-snake.simg "$TMPFILE"

# remove temp file
rm -f "$TMPFILE"

clean