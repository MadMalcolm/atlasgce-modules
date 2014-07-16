#!/bin/bash -l
#
# Condor startd jobwrapper
# Executes using bash -l, so that all /etc/profile.d/*.sh scripts are sourced.
#

# Workaround for condor not setting $HOME for worker sessions.
# voms-proxy-info requires this.
export HOME=`eval echo ~$USER`
exec "$@"
