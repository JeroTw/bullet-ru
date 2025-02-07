#!/bin/bash

IP_FILE="ipsum.lst"
curl -s https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/ipsum.lst -o "$IP_FILE"

if [ ! -f "$IP_FILE" ]; then
  echo "Ошибка: Не удалось скачать файл '$IP_FILE'"
  exit 1
fi

GATEWAY="172.16.250.1"
INTERFACE="tun0"


while IFS= read -r ip_range; do
  if [[ -z "$ip_range" || "$ip_range" =~ ^# ]]; then
    continue
  fi

  ip route add "$ip_range" via "$GATEWAY" dev "$INTERFACE"


done < "$IP_FILE"

rm "$IP_FILE"

echo "Готово."
