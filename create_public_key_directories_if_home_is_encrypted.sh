#!/bin/bash
# useful with encrypted home directories
# create folders at a specific location for ssh keys
# and set the safest file mode bits and correct owner

publickeydir="/etc/ssh/public_keys"
user=${1:-$USER}

if [ "$user" = root ] ; then
   printf "tzz ... do not use root for ssh!\n"
   exit 1
fi

if [ ! -f "/etc/ssh/revoked_keys" ] ; then
    printf "creating revoked_keys directory in /etc/ssh/\n"
    touch "/etc/ssh/revoked_keys"
    chown root:ssh "/etc/ssh/revoked_keys"
    chmod 640 "/etc/ssh/revoked_keys"
fi

if [ ! -d "$publickeydir" ] ; then
    printf "creating public_keys directory in /etc/ssh/\n"
    mkdir "$publickeydir"
    chown root:ssh "$publickeydir"
    chmod 710 "$publickeydir"
fi

if [ ! -d "$publickeydir/$user" ] ; then
    printf "creating ssh public key directory for USER: $user\n"
    mkdir "$publickeydir/$user"
    chown "$user":"$user" "$publickeydir/$user"
    chmod 700 "$publickeydir/$user"
else
    printf "ssh public key directory already exists for USER: $user\n"
    exit 2
fi

if [ ! -f "$publickeydir/$user/authorized_keys" ] ; then
    touch "$publickeydir/$user/authorized_keys"
    chown "$user":"$user" "$publickeydir/$user/authorized_keys"
    chmod 700 "$publickeydir/$user/authorized_keys"
else
    printf "authorized_keys file already exists in $publickeydir/$user/\n"
    exit 3
fi

exit 0
