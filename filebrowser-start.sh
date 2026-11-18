#!/usr/bin/with-contenv sh
set -eu

# The database settings are not imported from settings.json on existing installs.
exec s6-setuidgid abc sh -eu -c '
  db=/database/filebrowser.db
  if [ ! -f "$db" ]; then
    # Let File Browser create its initial administrator using its normal quick setup.
    filebrowser -c /config/settings.json &
    pid=$!
    ready=false
    for attempt in $(seq 1 60); do
      if curl -fsS http://127.0.0.1:80/health >/dev/null 2>&1 || curl -fsS http://127.0.0.1:80/ >/dev/null 2>&1; then
        ready=true
        break
      fi
      if ! kill -0 "$pid" 2>/dev/null; then
        wait "$pid"
        exit 1
      fi
      sleep 1
    done
    kill "$pid"
    wait "$pid" || true
    if [ "$ready" != true ]; then
      echo "File Browser initial setup did not become ready" >&2
      exit 1
    fi
  fi
  filebrowser config set -d "$db" --fileMode 0644 --dirMode 0755
  exec filebrowser -c /config/settings.json
'
