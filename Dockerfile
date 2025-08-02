FROM ubuntu:24.04

RUN apt-get update && apt-get install -y bash nano && apt-get clean

RUN mkdir -p /etc/application

COPY files/db.conf /etc/application/db.conf

COPY files/mock_systemctl.sh /usr/local/bin/systemctl
COPY files/start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/systemctl /usr/local/bin/start.sh

RUN chmod 400 /etc/application/db.conf

WORKDIR /root
CMD ["/usr/local/bin/start.sh"]
