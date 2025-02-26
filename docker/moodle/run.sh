#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

########################
# Check if the script is currently running as root
# Arguments:
#   $1 - user
#   $2 - group
# Returns:
#   Boolean
#########################
am_i_root() {
    if [[ "$(id -u)" = "0" ]]; then
        true
    else
        false
    fi
}

########################
# Start cron daemon
# Arguments:
#   None
# Returns:
#   true if started correctly, false otherwise
#########################
cron_start() {
    if [[ -x "/usr/sbin/cron" ]]; then
        /usr/sbin/cron
    elif [[ -x "/usr/sbin/crond" ]]; then
        /usr/sbin/crond
    else
        false
    fi
}

# Start cron
if am_i_root; then
    echo  "** Starting cron **"
    if ! cron_start; then
        error "Failed to start cron. Check that it is installed and its configur
ation is correct."
        exit 1
    fi
else
    warn "Cron will not be started because of running as a non-root user"
fi

# Start apache
    echo  "** Starting apache **"
exec /usr/sbin/apachectl -D FOREGROUND -k start
