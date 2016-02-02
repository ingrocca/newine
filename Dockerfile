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
  connman


RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -

RUN apt-get install --yes nodejs

RUN mkdir -p /app

COPY . /app

CMD configdev=$(blkid | grep "resin-conf" | awk '{print $1}' | tr -d ':')
CMD mkdir -p /mnt
CMD mount $configdev /mnt
CMD sed -r -i "s#\[WiFi\]\\\nEnable=true\\\nTethering=false#\[WiFi\]\\\nEnable=true\\\nTethering=true#" /mnt/config.json
CMD sync
CMD umount /mnt
CMD connmanctl tether wifi on NewineWAP 123456789


CMD cd /app && bash newine_server_init
