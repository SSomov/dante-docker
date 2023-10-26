#!/bin/bash

# Разделяем переменную среды CREDENTIALS на массив
IFS=',' read -ra USERS <<< "$CREDENTIALS"

# Создаем пользователей из CREDENTIALS
for CREDENTIAL in "${USERS[@]}"; do
    IFS=':' read -ra USER_INFO <<< "$CREDENTIAL"
    if [ "${#USER_INFO[@]}" -eq 2 ]; then
        USERNAME="${USER_INFO[0]}"
        PASSWORD="${USER_INFO[1]}"
        echo "Adding user $USERNAME"
        useradd -m "$USERNAME"
        echo "$USERNAME:$PASSWORD" | chpasswd
    fi
done

# Запуск Dante
exec sockd -f /etc/sockd.conf