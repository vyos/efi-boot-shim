# To build VyOS unsigned shim binary use the following instructions:
#
# $ docker build -t vyos/shim-build:rolling https://github.com/vyos/efi-boot-shim
# $ docker run --rm -it vyos/shim-build:rolling bash
# $ git clone https://github.com/vyos/efi-boot-shim
# $ cd efi-boot-shim && dpkg-buildpackage -uc -us -tc -b

FROM debian:trixie-20250630
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates

#########
##
## May need these 2 lines below as/when toolchain updates hit trixie
#RUN echo "deb [check-valid-until=no] https://snapshot.debian.org/archive/debian/20240422T205059Z/ unstable main" > /etc/apt/sources.list
#RUN echo "deb-src [check-valid-until=no] https://snapshot.debian.org/archive/debian/20240422T205059Z/ unstable main" >> /etc/apt/sources.list
##
#########

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    debhelper-compat \
    gnu-efi \
    sbsigntool \
    openssl \
    libelf-dev \
    gcc-12 \
    dos2unix \
    pesign \
    efivar \
    xxd \
    libefivar-dev
