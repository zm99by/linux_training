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
    chown student:student /var/log/mockdb

RUN cp /usr/local/setup/student.bashrc /home/student/.bashrc && \
    chown student:student /home/student/.bashrc

RUN chmod +x /usr/local/bin/systemctl \
             /usr/local/bin/start.sh \
             /usr/local/bin/mock_server.py && \
    chown student:student /etc/application/db.conf && \
    chmod 440 /etc/application/db.conf

RUN rm -rf /usr/local/setup/

# USER root
# RUN echo -e '#!/bin/sh\necho "sudo is disabled"; exit 1' > /usr/local/bin/sudo && \
#     chmod +x /usr/local/bin/sudo

USER student
WORKDIR /home/student

CMD ["/usr/local/bin/start.sh"]

