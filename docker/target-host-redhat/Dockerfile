FROM registry.access.redhat.com/ubi9-init:latest

RUN dnf install -y openssh-server python3 nmap-ncat && \
    dnf clean all && \
    ssh-keygen -A && \
    echo 'root:password' | chpasswd

COPY shared/lab-init.sh /usr/local/bin/lab-init.sh
COPY shared/lab-init.service /etc/systemd/system/lab-init.service

RUN chmod +x /usr/local/bin/lab-init.sh && \
    systemctl unmask systemd-logind && \
    systemctl enable sshd lab-init systemd-logind
