ARG VERSION
FROM registry.opensuse.org/opensuse/${VERSION}
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

# The following required for systemd to reliably detect the container 
ENV container docker

RUN zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution salt-minion systemd
COPY autologin.conf /etc/systemd/system/console-getty.service.d/autologin.conf
# Override default pam login configuration to allow autologin
RUN test -e /etc/pam.d/login || cp /usr/lib/pam.d/login /etc/pam.d/login
RUN sed -i -e '1s/^/auth sufficient pam_listfile.so item=tty sense=allow file=\/etc\/securetty onerr=fail apply=root/' /etc/pam.d/login
RUN echo console >> /etc/securetty

VOLUME ["/srv/salt"]
ENTRYPOINT ["/usr/lib/systemd/systemd", "--system"]
