FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y bash nano sudo grep && \
    apt-get clean

RUN mkdir -p /etc/application
COPY files/db.conf /etc/application/db.conf


COPY files/mock_systemctl.sh /usr/local/bin/systemctl
COPY files/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/systemctl /usr/local/bin/start.sh

RUN chown root:root /etc/application/db.conf && chmod 444 /etc/application/db.conf

RUN useradd -m -s /bin/bash student && \
    usermod -aG sudo student && \
    echo 'student ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/010-student-nopasswd

USER student
WORKDIR /home/student

CMD ["/usr/local/bin/start.sh"]