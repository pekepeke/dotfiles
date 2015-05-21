FROM ubuntu:14.10
RUN apt-get update -qq && apt-get install -y \
	build-essential \
	libpq-dev \
	libmcrypt-dev \
	libpng12-dev \
	libmysqlclient-dev
RUN apt-get install -y \
	git \
	tig \
	curl \
	zsh \
	tmux \
	xclip \
	cmigemo \
	libmigemo-dev \
	editorconfig \
	jq \
	unar \
	silversearcher-ag \
	exuberant-ctags \
	vim-nox \
	ruby2.0 \
	python3-dev \
	python-dev \
	ruby2.0-dev \
	libperl-dev \
	golang \
	php5 \
	php5-common \
	php5-cli \
	php5-curl \
	php5-gd \
	php5-intl \
	php5-json \
	php5-mcrypt \
	php5-mysql \
	php5-sqlite \
	php5-xdebug \
	php5-xhprof \
	libluajit-5.1-dev \
	libssl-dev \
	libreadline-dev \
	libsqlite3-dev \
	libclang-dev \
	libxml2-dev \
	libmcrypt-dev

# 	vim-lua \
# 	libcurl-dev \
# 	libbiz2-dev \

RUN curl -L https://raw.github.com/pekepeke/dotfiles/master/setup.sh | sh
RUN vim -c "silent NeoBundleInstall" -c "quitall"

COPY 000-default.conf /etc/apache2/sites-enabled/000-default.conf
RUN a2enmod ssl rewrite proxy_http php5 vhost_alias

COPY httpd-foreground /usr/local/bin/

EXPOSE 80
CMD ["httpd-foreground"]