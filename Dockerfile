FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache git
# Обновляем npm до последней версии
RUN npm install -g npm@latest

USER node
WORKDIR /usr/local/lib/node_modules/n8n
# Устанавливаем модуль, используя уже обновленный npm
RUN npm install officeparser
