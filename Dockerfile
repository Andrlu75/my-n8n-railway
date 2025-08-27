# Используем вашу версию n8n в качестве базового образа
FROM n8nio/n8n:1.108.1

# Переключаемся на пользователя root
USER root

# >>> ИСПРАВЛЕНИЕ <<<
# Обновляем npm до последней версии, чтобы он поддерживал протокол "workspace:"
RUN npm install -g npm@latest

# Теперь переходим в директорию установки n8n и устанавливаем officeparser.
RUN cd /usr/local/lib/node_modules/n8n \
 && npm install --omit=dev officeparser \
 && npm cache clean --force

# Проверка на этапе сборки (используем обновленный npm)
RUN cd /usr/local/lib/node_modules/n8n && node -e "console.log('officeparser path:', require.resolve('officeparser'))"

# Переключаемся обратно на стандартного пользователя n8n
USER node
