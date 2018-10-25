FROM opensuse/leap
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

ENV KBUILD_OUTPUT=/build

VOLUME ["/usr/src/linux", "/build", "/boot", "/etc/dracut.conf.d"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY run.sh /usr/local/bin
COPY installkernel /root/bin/installkernel

RUN zypper -n --gpg-auto-import-keys install --no-recommends --auto-agree-with-licenses --force-resolution btrfsprogs gcc grub2-i386-pc grub2-x86_64-efi iproute2 iputils hostname kmod kmod-compat libelf-devel make shim wicked
RUN zypper -n clean -a
RUN grub2-mkimage -O i386-pc-pxe -o /usr/local/lib/grub.pxe --prefix= echo http linux net normal pxe pxechain serial tftp
RUN grub2-mkimage -O x86_64-efi -o /usr/local/lib64/grub.efi --prefix= echo efi_gop efi_uga efinet http linux linuxefi net normal serial tftp

COPY dracut.conf.d/90-network.conf /usr/lib/dracut/dracut.conf.d
COPY dracut.conf.d/95-noroot.conf /usr/lib/dracut/dracut.conf.d
COPY modules.d/95noroot /usr/lib/dracut/modules.d/95noroot
