FROM scratch
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>
ADD opensuse-leap-15.0-image.armv7l-1.0.0-lxc-Buildlp150.8.1.tar.xz /
RUN for I in /etc/zypp/repos.d/*.repo; do sed -i $I -e 's/arm/armv7hl/g'; done
