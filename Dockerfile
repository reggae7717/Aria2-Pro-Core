ARG BUILDER_IMAGE=debian:12

FROM $BUILDER_IMAGE AS builder

WORKDIR /P3TERX/aria2-builder

COPY . .

ENV DEBIAN_FRONTEND=noninteractive

ARG BUILD_SCRIPT=aria2-gnu-linux-build.sh
ARG ARIA2_BUILD_SYSTEM=autotools
ARG ARIA2_REPOSITORY=https://github.com/aria2/aria2.git
ARG ARIA2_REF=master

ENV ARIA2_BUILD_SYSTEM=${ARIA2_BUILD_SYSTEM} \
    ARIA2_REPOSITORY=${ARIA2_REPOSITORY} \
    ARIA2_REF=${ARIA2_REF}

RUN bash $BUILD_SCRIPT

FROM scratch

COPY --from=builder /root/output /
