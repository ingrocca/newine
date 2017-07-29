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
  ssh \
  sshpass \
  cron \
  logrotate



RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

RUN apt-get install --yes nodejs

RUN mkdir -p /app

COPY . /app

RUN cp /app/newine_cron /etc/cron.d/
RUN chmod 0644 /etc/cron.d/newine_cron

RUN gem install i18n -v '0.6.5'
RUN gem install require_all -v '1.3.1'
RUN gem install atomic -v '1.1.14'
RUN gem install sqlite3 -v '1.3.8'
RUN gem install rake -v '10.1.0'

RUN cd /app && gem install bundler && bundler install


CMD configdev=$(blkid | grep "resin-conf" | awk '{print $1}' | tr -d ':') \
  && connmanctl tether wifi on Newine dispenser \
  && memcached -d -u  root \
  && cd /app && rake db:migrate && rake db:seed && bash newine_server_init

ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket
