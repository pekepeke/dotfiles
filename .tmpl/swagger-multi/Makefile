.PHONY: clean

default:

install:
	npm install

ui:
	docker-compose up -d

ui-stop:
	docker-compose stop

watch:
	node resolve.js -w -O api.yaml -o yaml index.yaml

clean:
