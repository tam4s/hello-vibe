# hello-vibe

Proof-of-concept vibe-d http server packaged into a docker image.

## How to run

    docker run -it --publish 8888:8888 tam4s/hello-vibe-x86_64
or
    docker run -it --publish 8888:8888 tam4s/hello-vibe-armv7l

## How to build docker image

Steps to build hello-vibe docker image if you only have docker installed:

	docker run -v /var/run/docker.sock:/var/run/docker.sock -ti docker
	apk update
	apk add git
	git clone https://github.com/tam4s/hello-vibe
	cd hello-vibe
	./build-docker-image.sh
	IMG_NAME=tam4s/hello-vibe-$(uname -m)
	docker build -t $IMG_NAME .
	docker login
	docker push $IMG_NAME
