# Используем официальный образ n8n как основу
FROM n8nio/n8n:latest

# Устанавливаем git, который может понадобиться для некоторых npm пакетов
USER root
RUN apk add --no-cache git
USER node

# Явно указываем рабочую директорию для установки
WORKDIR /home/node/.n8n/

# Устанавливаем модуль
RUN npm install officeparser

# ДЛЯ ДИАГНОСТИКИ: выводим содержимое папки, чтобы убедиться, что модуль на месте
RUN ls -la
