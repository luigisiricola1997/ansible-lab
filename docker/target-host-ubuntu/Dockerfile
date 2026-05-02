FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        python3 \
        netcat-openbsd \
        systemd \
        systemd-sysv \
        dbus && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    ssh-keygen -A && \
    echo 'root:password' | chpasswd && \
    sed -i '1i UsePAM no' /etc/ssh/sshd_config

COPY shared/lab-init.sh /usr/local/bin/lab-init.sh
COPY shared/lab-init.service /etc/systemd/system/lab-init.service

RUN chmod +x /usr/local/bin/lab-init.sh && \
    systemctl enable ssh lab-init

CMD ["/sbin/init"]
