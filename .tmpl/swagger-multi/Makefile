.PHONY: clean

# https://hub.docker.com/r/swaggerapi/swagger-codegen-cli/tags
CODEGEN_DOCKER_VER = 2.4.1

default:

install:
	npm install
	docker pull swaggerapi/swagger-codegen-cli:${CODEGEN_DOCKER_VER}

ui:
	docker-compose up -d

ui-stop:
	docker-compose stop

gen-swift:
	docker run --rm -v ${PWD}:/local swaggerapi/swagger-codegen-cli:${CODEGEN_DOCKER_VER} generate \
		-i /local/api.yaml \
		-l swift4 \
		-o /local/swift4

watch:
	node resolve.js -w -O api.yaml -o yaml index.yaml

clean:
