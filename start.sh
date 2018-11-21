#!/bin/bash

# Note: set user using `--env uid=XXXX --env gid=XXXX`, instead of using
# docker's `--user` flag

if [[ "${uid}" && "${gid}" ]] ; then
    set -e
    if ! grep --quiet ":${gid}:" /etc/group; then
        groupadd --gid "${gid}" cocaptain
    fi
    if ! grep --quiet ":x:${uid}:" /etc/passwd; then
        useradd \
            --home-dir "$HOME" \
            --uid ${uid} \
            --gid ${gid} \
            --groups sudo \
            cocaptain
    fi
    if ((1000 != ${uid} || 1000 != ${gid} )) ; then
        chown ${uid}:${gid} "/opt"
    fi
    su_cmd="sudo --preserve-env PATH=${PATH} --user #${uid} --group #${gid}"
    set +e
fi

if (( $# == 0 )); then
    set sdf-e
	${su_cmd} /bin/bash
else
    set -e
	${su_cmd} /usr/local/bin/eclipse-headless.sh "$@"
fi
