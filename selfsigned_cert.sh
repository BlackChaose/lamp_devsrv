#!/bin/bash
#------------------------------------------- Some Theory --------------------------------------------------------------------------------
##create secret key
#openssl genrsa -out my_site.key 2048
##create Certificate Signing Request CN - must have as ServerName in apache2's site's config
#openssl req -new -key my_site.key -out nvdn.debug.csr
##selfsigned certificate on 365 days
#openssl x509 -req -days 365 -in my_sitecsr -signkey nvdn.debug.key -out nvdn.debug.crt
#-------------------------------------------------------------------------------------------------------------------------------------------------

# Проверка, передано ли имя домена как аргумент
if [ -z "$1" ]; then
    echo "Ошибка: необходимо указать имя домена."
    echo "Пример использования: $0 <имя_домена> [страна] [регион] [город] [организация] [подразделение] [email]"
    exit 1
fi

DOMAIN=$1

# Задание значений по умолчанию для полей
COUNTRY="${2:-RU}"
STATE="${3:-Moscow}"
LOCALITY="${4:-Moscow}"
ORGANIZATION="${5:-HOME}"
ORG_UNIT="${6:-IT}"
EMAIL="${7:-admin@$DOMAIN}"

# Сборка строки для запроса на сертификат
SUBJECT="/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$DOMAIN/emailAddress=$EMAIL"

# Создание приватного ключа
openssl genrsa -out "$DOMAIN.key" 2048

# Создание запроса на сертификат (CSR)
openssl req -new -key "$DOMAIN.key" -out "$DOMAIN.csr" -subj "$SUBJECT"

# Создание самоподписанного сертификата на 365 дней
openssl x509 -req -days 365 -in "$DOMAIN.csr" -signkey "$DOMAIN.key" -out "$DOMAIN.crt"

# Очистка временных файлов
rm "$DOMAIN.csr"

echo "Самоподписанные сертификаты для $DOMAIN созданы:"
echo "$DOMAIN.key - приватный ключ"
echo "$DOMAIN.crt - сертификат"
