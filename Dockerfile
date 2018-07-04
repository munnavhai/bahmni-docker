FROM centos:6.9
MAINTAINER ehealthsupport@brussels.msf.org

RUN yum install -y epel-release && \
    yum install -y sudo \
                   crontabs \
                   python \
                   p7zip \
                   openssh-server \
                   rsync \
                   python-pip \
                   ansible && \
    yum clean all

COPY config.sh /
COPY stage1/ /ansible/
COPY artifacts/ /tmp/artifacts/
COPY install.sh /tmp/

ARG impl_file_suffix
COPY inventory_${impl_file_suffix} /inventory

ARG bahmni_installer_url
ARG bahmni_implementation_repo
ARG bahmni_implementation_branch
RUN bash -e /tmp/install.sh

COPY stage2/ /ansible/
COPY keys /tmp/artifacts/keys/
COPY post_install.sh /tmp/
RUN bash -e /tmp/post_install.sh

COPY start.sh /

# https://vsupalov.com/docker-build-time-env-values/

