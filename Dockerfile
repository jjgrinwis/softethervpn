FROM debian:latest
MAINTAINER John Grinwis "john@grinwis.com"

ENV VERSION v4.17-9562-beta-2015.05.30
WORKDIR /usr/local/vpnserver

RUN apt-get -qq update
RUN apt-get -qq upgrade
RUN apt-get -qq install wget make gcc -y
RUN apt-get clean
RUN rm -rf /var/cache/apt/* /var/lib/apt/lists/*
RUN wget http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnserver.tar.gz
RUN tar xf /tmp/softether-vpnserver.tar.gz -C /usr/local/
RUN rm /tmp/softether-vpnserver.tar.gz
RUN make i_read_and_agree_the_license_agreement
RUN apt-get purge -y -q --auto-remove gcc make wget

# expose some ports
# 500/udp ISAKMP
# 4500/udp IPSEC NAT
# 443/tcp HTTPS
EXPOSE 500/udp 4500/udp 443/tcp

# use execsvc to run in foreground
CMD ["/usr/local/vpnserver/vpnserver","execsvc"]
