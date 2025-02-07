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

  # Проверяем, что маска подсети /24 или меньше
  subnet_mask=$(echo "$ip_range" | cut -d'/' -f2)

  if [[ -n "$subnet_mask" && "$subnet_mask" -le 24 ]]; then
    ip route add "$ip_range" via "$GATEWAY" dev "$INTERFACE"
  fi

done < "$IP_FILE"

rm "$IP_FILE"

echo "Готово."
