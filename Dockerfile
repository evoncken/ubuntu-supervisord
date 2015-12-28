# ubuntu-supervisord
#   Demo container for running multiple services under supervisord
#   Source: https://docs.docker.com/engine/articles/using_supervisord/

FROM ubuntu:latest
MAINTAINER Ed Voncken <docker@edvoncken.net>

# Add packages as needed
RUN export DEBIAN_FRONTEND='noninteractive' && \
    apt-get update -qq && \
    apt-get install -qqy --no-install-recommends \
            apache2 \
            openssh-server \
            supervisor \
            $(apt-get -s dist-upgrade|awk '/^Inst.*ecurity/ {print $2}') && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY index.html /var/www/html/index.html

EXPOSE 22 80

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
