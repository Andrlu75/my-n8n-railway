# Используем официальный образ n8n как основу
FROM n8nio/n8n:latest

# Создаём новую, безопасную директорию для наших модулей
RUN mkdir /custom_modules

# Устанавливаем git, который может понадобиться для некоторых npm пакетов
USER root
RUN apk add --no-cache git
USER node

# Явно указываем эту новую директорию как рабочую
WORKDIR /custom_modules

# Устанавливаем модуль
RUN npm install officeparser
