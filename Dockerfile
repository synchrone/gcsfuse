FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install --yes --no-install-recommends ca-certificates curl gnupg lsb-release && \
    echo "deb http://packages.cloud.google.com/apt gcsfuse-`lsb_release -c -s` main" > /etc/apt/sources.list.d/gcsfuse.list && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    groupadd fuse && \
    useradd -g fuse fuse && \
    apt-get update && apt-get install --yes --no-install-recommends gcsfuse && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

ENV UID=33 GID=33 MOUNT='/mnt' BUCKET='' BDIR='/'
CMD userdel $(getent passwd | grep x:$UID | cut -d: -f1); \
    usermod -u $UID fuse && \
    groupdel $(getent group | grep x:$GID | cut -d: -f1); \
    groupmod -g $GID fuse && \
    chown fuse:fuse /mnt && \
    su -p -c "HOME=/home/fuse gcsfuse --foreground -o nonempty --only-dir $BDIR $BUCKET $MOUNT" fuse

#docker run -it --rm --device /dev/fuse --cap-add SYS_ADMIN --security-opt apparmor:unconfined \
#  -v ~/.config/gcloud/application_default_credentials.json:/home/fuse/.config/gcloud/application_default_credentials.json \
#   gcsfuse:latest
