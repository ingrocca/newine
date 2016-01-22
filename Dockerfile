FROM resin/beaglebone-debian

RUN apt-get update && apt-get install \
  build-essential \
  g++ \
  gcc \
  libjansson-dev \
  libnfc-dev \
  libcurl4-openssl-dev \
  dpkg \
  daemon \
  ruby \
  ruby-dev \
  dropbear \
  thin \
  curl \
  device-tree-compiler

RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

RUN apt-get install --yes nodejs

RUN mkdir -p /app

COPY . /app

CMD cd /app && bash newine_server_init
