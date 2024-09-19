FROM restic/restic:latest

RUN apk add --update --no-cache rclone bash tini
RUN mkdir -p /backup

WORKDIR /backup

ADD --chmod=770 start.sh /backup/start.sh
ADD --chmod=770 backup.sh /backup.sh

ENTRYPOINT ["/sbin/tini", "--"]

CMD bash /backup/start.sh