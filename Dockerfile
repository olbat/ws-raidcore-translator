FROM olbat/docker-debian-ruby-nokogiri
MAINTAINER devel@olbat.net

RUN mkdir -p /src

# Setup UTF-8 locales
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y locales
ENV DEBIAN_FRONTEND ""
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en


# Copy Raidcore sources from GitHub repository
#ADD http://github.com/NielsH/Raidcore/archive/master.tar.gz /tmp/
#RUN tar -C /tmp/ -zxf /tmp/master.tar.gz
#RUN rm -f /tmp/master.tar.gz
#RUN mv /tmp/RaidCore-master /src/Raidcore

# Copy Raidcore sources from git submodule
#COPY Raidcore /src/

# Copy the script
COPY raidcore-translator /usr/local/bin/

CMD ["raidcore-translator","convert","-v","/src/Modules"]

VOLUME ["/src"]
