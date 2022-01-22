FROM ubuntu:22.04

LABEL maintainer="pa733 <admin@ypemc.com>"

ENV FRP_VERSION 0.38.0

RUN cd /root \
    && apt-get update && apt-get install -y wget systemd  \
    &&  wget --no-check-certificate -c https://ghproxy.com/github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  tar zxvf frp_${FRP_VERSION}_linux_amd64.tar.gz  \
    &&  cd frp_${FRP_VERSION}_linux_amd64/ \
    &&  cp frps /usr/bin/ \
    &&  mkdir -p /etc/frp \
    &&  cp frps.ini /etc/frp \
    &&  echo "kcp_bind_port = 7000 \n" >> /etc/frp/frps.ini \
    && cd /root && echo ' \
    #! /bin/bash \
    echo "token = ${token}" >> /etc/frp/frps.ini &&\
    /usr/bin/frps -c /etc/frp/frps.ini \
    ' >> ./start.sh && chmod +x ./start.sh \
    &&  cd /root \
    &&  rm frp_${FRP_VERSION}_linux_amd64.tar.gz \
    &&  rm -rf frp_${FRP_VERSION}_linux_amd64/

CMD /root/start.sh
