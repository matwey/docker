FROM registry.opensuse.org/virtualization/containers/images/opensuse-leap-15.0/containers_ports/opensuse-leap-15.0:current
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

ENV KBUILD_OUTPUT=/build

VOLUME ["/usr/src/linux", "/build", "/boot", "/etc/dracut.conf.d"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY run.sh /usr/local/bin
COPY installkernel /root/bin/installkernel

RUN zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution btrfsprogs gcc grub2-arm64-efi iproute2 iputils hostname kmod kmod-compat libelf-devel make wicked
RUN zypper -n clean -a
RUN grub2-mkimage -O arm64-efi -o /usr/local/lib64/grub.efi --prefix= echo efi_gop efinet http linux net normal serial tftp

COPY dracut.conf.d/90-network.conf /usr/lib/dracut/dracut.conf.d
COPY dracut.conf.d/95-noroot.conf /usr/lib/dracut/dracut.conf.d
COPY modules.d/95noroot /usr/lib/dracut/modules.d/95noroot
