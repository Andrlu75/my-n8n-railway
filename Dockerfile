FROM n8nio/n8n:latest

# Переключаемся на администратора для подготовки окружения
USER root
RUN apk add --no-cache git
# Обновляем npm глобально до последней версии
RUN npm install -g npm@latest

# Возвращаемся к обычному пользователю
USER node
# Указываем рабочую директорию
WORKDIR /usr/local/lib/node_modules/n8n
# Устанавливаем пакет, используя уже обновленный npm
RUN npm install officeparser
