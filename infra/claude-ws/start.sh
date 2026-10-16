#!/usr/bin/env bash
# Uruchamia serwer Remote Control w tmux i trzyma kontener przy życiu.
# Pętla restartuje serwer, gdy wyjdzie (np. po ~10 min bez sieci).
set -u
NAME="${RC_NAME:-docker-workstation}"
CAPACITY="${RC_CAPACITY:-4}"

if ! tmux has-session -t claude 2>/dev/null; then
  tmux new-session -d -s claude -c /workspace \
    "while true; do claude remote-control --name '$NAME' --capacity $CAPACITY --continue \
       || claude remote-control --name '$NAME' --capacity $CAPACITY; \
     echo 'remote-control zakończył pracę, restart za 10 s'; sleep 10; done"
fi

# Trzymaj kontener przy życiu, dopóki działa tmux
while tmux has-session -t claude 2>/dev/null; do sleep 30; done
