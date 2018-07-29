FROM matwey/opensuse-go
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

# The following required to overcome govendor issue:
#
# failed to copy package from
# "/root/go/.cache/govendor/github.com/prometheus/procfs" to
# "/root/go/src/github.com/influxdata/influxdb/vendor/github.com/prometheus/procfs":
# stat
# /root/go/.cache/govendor/github.com/prometheus/procfs/fixtures/26231/exe: no
# such file or directory
#
RUN zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution vim

COPY ./run.sh /
RUN mkdir /data

VOLUME ["/data"]
ENTRYPOINT ["/run.sh"]
