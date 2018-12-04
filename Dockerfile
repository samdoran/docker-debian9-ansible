FROM debian:stretch
ENV container=docker
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
        systemd systemd-cron sudo curl gnupg2 dirmngr\
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean

RUN apt-add-repository 'deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main' \
    && APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 \
    && apt-get update \
    && apt-get upgrade -y --no-install-recommends \
    && apt-get install -y ansible \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && touch -m -t 201701010000 /var/lib/apt/lists/

# Install Ansible inventory file.
RUN echo '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup"]
CMD ["/lib/systemd/systemd"]
