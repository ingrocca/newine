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
  device-tree-compiler \
  git-core \
  libsqlite3-dev \
  connman \
  libevent-dev \
  memcached \
  ssh




RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

RUN apt-get install --yes nodejs

RUN mkdir -p /app

COPY . /app

RUN gem install i18n -v '0.6.5'
RUN gem install require_all -v '1.3.1'
RUN gem install atomic -v '1.1.14'
RUN gem install sqlite3 -v '1.3.8'
RUN gem install rake -v '10.1.0'

RUN cd /app && gem install bundler && bundler install
RUN cd /app && rake db:migrate

CMD configdev=$(blkid | grep "resin-conf" | awk '{print $1}' | tr -d ':') \
  && mount $configdev /mnt \
  && sed -r -i "s#\[WiFi\]\\\nEnable=true\\\nTethering=false#\[WiFi\]\\\nEnable=true\\\nTethering=true#" /mnt/config.json \
  && sync \
  && umount /mnt \
  && connmanctl tether wifi on Newine dispenser \
  && memcached -d -u  root \
  && cd /app && bash newine_server_init
