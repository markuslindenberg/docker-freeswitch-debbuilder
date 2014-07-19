FROM debian:wheezy
MAINTAINER Markus Lindenberg <markus.lindenberg@gmail.com>

# Make Debconf less annoying
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

# Add aptly repository
RUN echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list
RUN gpg -q --keyserver keys.gnupg.net --recv-keys 2A194991
RUN gpg -a --export 2A194991 | apt-key add -

# Install toolchain
RUN apt-get update
RUN apt-get -y install git build-essential devscripts git-buildpackage aptly python sudo fakeroot rsync
RUN apt-get clean

# Create users
RUN adduser --system --home /usr/src/source source
RUN adduser --system --home /usr/src/build build
RUN adduser --system --home /srv/aptly aptly

# Yay FreeSWITCH
RUN sudo -u source git clone https://stash.freeswitch.org/scm/fs/freeswitch.git /usr/src/source/freeswitch

# Initialize repository
RUN echo '{"rootDir": "/srv/aptly"}' | python -mjson.tool > /etc/aptly.conf
RUN sudo -u aptly aptly repo create freeswitch
RUN echo "deb-src file:///srv/aptly/public/ wheezy main" > /etc/apt/sources.list.d/freeswitch_source.list

# Add build script
ADD build.sh /usr/src/build.sh
WORKDIR /usr/src
CMD ["/usr/src/build.sh"]
