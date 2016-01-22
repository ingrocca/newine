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

RUN npm install -g octalbonescript_capemgr4_1

RUN mkdir -p /app

COPY . /app

RUN cd /app && gem install bundler && bundle install


RUN chmod +x /app/bb.org-overlays-master/dtc-overlay.sh

RUN ./app/bb.org-overlays-master/dtc-overlay.sh

RUN cd /app && make all

CMD cd /app && bash newine_server_init
