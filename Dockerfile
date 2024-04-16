FROM docker:dind

# Install bin/bash to be able to use it
RUN apk update
RUN apk upgrade

# Install SSH Server
RUN apk update \
    && apk upgrade \
    && apk add bash curl openvpn openrc iptables \
    && rm -rf /var/cache/apk/* \
    && rc-update add openvpn default \
    && echo "tun" >> /etc/modules
RUN apk add --update --no-cache openssh 
RUN rc-update add sshd
# RUN service sshd start

# Install Git
RUN apk update \
    && apk upgrade \
	&& apk add git

# Install Python3 & pip
RUN apk add --no-cache python3 py3-pip

# Get the script for SSH
# COPY entrypoint.sh /
# RUN echo "#!/bin/sh" >> /entrypoint.sh
RUN echo "ssh-keygen -A" >> /entrypoint.sh
RUN echo 'exec /usr/sbin/sshd -D -e "$@"' >> /entrypoint.sh
RUN chmod +x -v /entrypoint.sh

# Configure SSH
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/sonem -s /bin/sh -D sonem
RUN echo -n 'sonem:sonem12345' | chpasswd

# Add sonem to the docker user group
RUN addgroup sonem docker

# sh /entrypoint.sh &
# CMD ["/entrypoint.sh"]
# CMD ["sh", "/entrypoint.sh"]

# Expose Port
EXPOSE 22

# Commands
# docker build -t my-docker-image:v0.0.1 .
# docker run --privileged -p 0.0.0.0:33:22 -d --name my-docker-container my-docker-image:v0.0.1
# docker exec -it my-docker-container bash
# Get in and run 'sh /entrypoint.sh &' and then CTRL + C

# How to connect
# ssh sonem@remotehostip -p 33

# https://www.cyberciti.biz/faq/how-to-install-openssh-server-on-alpine-linux-including-docker/