#!/bin/bash
set -e +xv
trap "rm -rf /root/.zypp" EXIT

ARTIFACTORY_USERNAME=$(test -f /run/secrets/ARTIFACTORY_READONLY_USER && cat /run/secrets/ARTIFACTORY_READONLY_USER)
ARTIFACTORY_PASSWORD=$(test -f /run/secrets/ARTIFACTORY_READONLY_TOKEN && cat /run/secrets/ARTIFACTORY_READONLY_TOKEN)
SLES_MIRROR="https://${ARTIFACTORY_USERNAME:-}${ARTIFACTORY_PASSWORD+:}${ARTIFACTORY_PASSWORD}@artifactory.algol60.net/artifactory/sles-mirror"
SLES_VERSION=15-SP5
ARCH=x86_64
zypper --non-interactive rr --all
zypper --non-interactive ar ${SLES_MIRROR}/Products/SLE-Module-Basesystem/${SLES_VERSION}/${ARCH}/product?auth=basic sles15sp5-Module-Basesystem-product
zypper --non-interactive ar ${SLES_MIRROR}/Updates/SLE-Module-Basesystem/${SLES_VERSION}/${ARCH}/update?auth=basic sles15sp5-Module-Basesystem-update
zypper update -y
zypper install -y awk \
                  curl \
                  glibc-locale-base \
                  gzip \
                  jq \
                  less \
                  rsync \
                  tar \
                  vim \
                  wget \
                  which

zypper clean -a && zypper --non-interactive rr --all && rm -f /etc/zypp/repos.d/*
