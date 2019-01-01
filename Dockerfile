FROM opensuse/leap
MAINTAINER Matwey V. Kornilov <matwey.kornilov@gmail.com>

ENV KBUILD_OUTPUT=/build
ENV CROSS_COMPILE=aarch64-suse-linux-
ENV CROSS_CM3=arm-none-eabi-

VOLUME ["/boot"]

ENTRYPOINT ["/usr/local/bin/run.sh"]

COPY libgcc.a /usr/local/lib

COPY install.sh /usr/local/bin
RUN /usr/local/bin/install.sh

COPY run.sh /usr/local/bin
