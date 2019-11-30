FROM opensuse/leap
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

VOLUME ["/var/log/clickhouse-server", "/var/lib/clickhouse-server", "/etc/clickhouse-server"]
ENTRYPOINT ["/usr/local/bin/run.sh"]
EXPOSE 9000/tcp

COPY install.sh /usr/local/bin
COPY run.sh /usr/local/bin

RUN /usr/local/bin/install.sh
