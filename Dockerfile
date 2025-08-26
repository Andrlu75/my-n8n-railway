FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache git

# Создаем отдельную директорию для кастомных модулей
RUN mkdir -p /usr/local/n8n-custom
RUN chown -R node:node /usr/local/n8n-custom

USER node
WORKDIR /usr/local/n8n-custom

# Инициализируем новый npm проект и устанавливаем модуль
RUN npm init -y
RUN npm install officeparser

# Возвращаемся в стандартную рабочую директорию
WORKDIR /home/node
