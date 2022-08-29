#!/usr/bin/bash

set -x

# Create non-root user
NEW_GROUP=${NEW_GROUP:-ubuntu}
NEW_USER=${NEW_USER:-ubuntu}
USER_PASSWORD=${USER_PASSWORD:-ChangeMe}

if [ $(cat /etc/group|grep "^$NEW_GROUP:"|wc -l) -eq 0 ]; then
    groupadd $NEW_GROUP
fi

if [ $(cat /etc/passwd|grep "^$NEW_USER:"|wc -l) -eq 0 ]; then
	useradd -s /bin/bash -m -g $NEW_GROUP $NEW_USER
	echo "$NEW_USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ubuntu
	echo "$NEW_USER:$USER_PASSWORD" | chpasswd
fi

exec sudo -S /usr/sbin/sshd -D
