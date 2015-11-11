DOCKER_IMAGE="metavige/registry-nginx"

build:
	docker build -t ${DOCKER_IMAGE} .

push:
	docker push ${DOCKER_IMAGE}
