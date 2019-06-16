#!/bin/bash

result=`ps aux | grep "ssh-agent" | grep -v "defunct" | grep -v "grep"`

[ -z "$result" ] && ssh-agent > ~/.tmp/ssh_vars

exit 0

