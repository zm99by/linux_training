FROM ubuntu:24.04

RUN apt-get update && \
    apt-get install -y \
        bash \
        sudo \
        grep \
        curl \
        vim \
        python3 \
        procps && \
    apt-get clean

RUN mkdir -p /etc/application \
    && mkdir -p /var/log/mockdb

COPY files/ /usr/local/setup/

RUN cp /usr/local/setup/db.conf /etc/application/db.conf && \
    cp /usr/local/setup/mock_systemctl.sh /usr/local/bin/systemctl && \
    cp /usr/local/setup/start.sh /usr/local/bin/start.sh && \
    cp /usr/local/setup/mock_server.py /usr/local/bin/mock_server.py

RUN useradd -m -s /bin/bash student && \
    usermod -aG sudo student && \
    echo 'student ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/010-student-nopasswd && \
    chown student:student /var/log/mockdb

RUN cp /usr/local/setup/student.bashrc /home/student/.bashrc && \
    chown student:student /home/student/.bashrc

RUN chmod +x /usr/local/bin/systemctl \
             /usr/local/bin/start.sh \
             /usr/local/bin/mock_server.py && \
    chown root:root /etc/application/db.conf && \
    chmod 444 /etc/application/db.conf

RUN rm -rf /usr/local/setup/

USER student
WORKDIR /home/student
CMD ["/usr/local/bin/start.sh"]

