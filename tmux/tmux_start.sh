#!/bin/sh
# SPDX-License-Identifier: MIT

#TMUX startup

tmux new-session \; \
  send-keys 'tail -f /var/log/messages' C-m \; \
  split-window -v -p 75 \; \
  split-window -h -p 25 \; \
  send-keys 'top -SPT' C-m \; \
  select-pane -t 1 \; \
  set status-left "#(~/tmuxstatus.sh tc) "\; \
  set status-right-length 120 \; \
  set status-right "#(~/tmuxstatus.sh net) ";