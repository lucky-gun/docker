#!/bin/bash
SRC_ON="/home/opc/pub_svc/traefik/data/dynamic_conf/enabled/dynamic.yml"
SRC_OFF="/home/opc/pub_svc/traefik/data/dynamic_conf/disabled/dynamic.yml"
DEST="/home/opc/pub_svc/traefik/data/dynamic_conf/active/dynamic.yml"

if cmp -s "$DEST" "$SRC_ON"; then
  cp "$SRC_OFF" "$DEST"
  echo "🔒 Infra 접근 차단됨"
else
  cp "$SRC_ON" "$DEST"
  echo "✅ Infra 접근 허용됨"
fi

sudo docker compose exec my_traefik kill -HUP 1
