#!/bin/bash

# IP адрес шлюза
GATEWAY="172.16.250.1"

# Интерфейс туннеля
TUN_INTERFACE="tun0"

# Получаем список IPv4 диапазонов Cloudflare
IP_RANGES_CLOUDFLARE=$(curl -s https://www.cloudflare.com/ips-v4/)

# Проверяем, успешно ли получили данные Cloudflare
if [ -z "$IP_RANGES_CLOUDFLARE" ]; then
  echo "Ошибка: Не удалось получить список диапазонов IP адресов Cloudflare."
  exit 1
fi

# Получаем список IPv4 диапазонов Telegram
IP_RANGES_TELEGRAM=$(curl -s https://core.telegram.org/resources/cidr.txt | grep -v ":") # Фильтруем IPv6

# Проверяем, успешно ли получили данные Telegram
if [ -z "$IP_RANGES_TELEGRAM" ]; then
  echo "Ошибка: Не удалось получить список диапазонов IP адресов Telegram."
  exit 1
fi

# Функция для добавления маршрута
add_route() {
  RANGE="$1"
  echo "Добавление маршрута: $RANGE"
  ip route add "$RANGE" via "$GATEWAY" dev "$TUN_INTERFACE"
  # Проверяем код возврата команды ip route add
  if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось добавить маршрут для $RANGE"
  fi
}

# Обрабатываем каждый диапазон Cloudflare
echo "$IP_RANGES_CLOUDFLARE" | while read RANGE; do
  add_route "$RANGE"
done

# Обрабатываем каждый диапазон Telegram
echo "$IP_RANGES_TELEGRAM" | while read RANGE; do
  add_route "$RANGE"
done


echo "Завершено добавление маршрутов Cloudflare и Telegram."
