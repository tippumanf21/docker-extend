FROM nginx:1.20-alpine

#RUN mkdir /work
#
# Install OpenSSH and set the password for root to "Docker!". In this example, "apk add" is the install instruction for an Alpine Linux-based image.
RUN apk add openssh \
     && echo "root:Docker!" | chpasswd 
     
RUN { \
    echo 'Port            2222'; \
    echo 'ListenAddress       0.0.0.0'; \
    echo 'LoginGraceTime      180'; \
    echo 'X11Forwarding       yes'; \
    echo 'Ciphers aes128-cbc,3des-cbc,aes256-cbc,aes128-ctr,aes192-ctr,aes256-ctr'; \
    echo 'MACs hmac-sha1,hmac-sha1-96'; \
    echo 'StrictModes         yes'; \
    echo 'SyslogFacility      DAEMON'; \
    echo 'PasswordAuthentication  yes'; \
    echo 'PermitEmptyPasswords    no'; \
    echo 'PermitRootLogin     yes'; \
    echo 'Subsystem sftp internal-sftp'; \
    } > /etc/ssh/sshd_config 
     
RUN { \
    echo '#!/bin/sh'; \
    echo "if [ ! -f '/etc/ssh/ssh_host_rsa_key' ]; then                     "; \
    echo "  ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa            "; \
    echo "fi                                                                "; \
    echo "                                                                  "; \
    echo "if [ ! -f '/etc/ssh/ssh_host_dsa_key' ]; then                     "; \
    echo "  ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa            "; \
    echo "fi                                                                "; \
    echo "                                                                  "; \
    echo "if [ ! -f '/etc/ssh/ssh_host_ecdsa_key' ]; then                   "; \
    echo "  ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t dsa          "; \
    echo "fi                                                                "; \
    echo "if [ ! -f '/etc/ssh/ssh_host_ed25519_key' ]; then                 "; \
    echo "  # generate fresh ecdsa key                                      "; \
    echo "  ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t dsa        "; \
    echo "fi                                                                "; \
    echo "if [ ! -d '/var/run/sshd' ]; then                                 "; \
    echo "  mkdir -p /var/run/sshd                                          "; \
    echo "fi                                                                "; \
    echo '/usr/sbin/sshd'; \
    } > docker-entrypoint.d/40-run-openssh.sh
     
RUN chmod 777 /docker-entrypoint.d/40-run-openssh.sh
EXPOSE 80 8080 2222

ENTRYPOINT ["/docker-entrypoint.sh"]
STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]