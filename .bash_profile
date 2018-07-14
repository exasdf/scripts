export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> /var/log/$USER/bash-history-$(date "+%Y-%m-%d").log; fi'
