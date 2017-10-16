.PHONY: clean

default:

build: composer.lock
	@if [ ! -f box.phar ]; then curl -Lo box.pha https://github.com/box-project/box2/releases/download/2.6.0/box-2.6.0.phar ; fi
	php box.phar build

composer.lock: composer.json
	composer install --no-dev --optimize-autoloader

clean:
	rm composer.lock
