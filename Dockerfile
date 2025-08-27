FROM n8nio/n8n:1.108.1

# Переключаемся на root для модификации системных файлов
USER root

# Переходим в директорию установки n8n и устанавливаем пакет
RUN cd /usr/local/lib/node_modules/n8n \
 && npm install --omit=dev officeparser \
 && npm cache clean --force

# Устанавливаем необходимые переменные окружения для разрешения использования
# (Их также можно установить через интерфейс Railway, но указание в Dockerfile гарантирует их наличие)
ENV NODE_FUNCTION_ALLOW_EXTERNAL=officeparser
# Разрешаем встроенные модули (fs, path и т.д.), которые могут понадобиться officeparser
ENV NODE_FUNCTION_ALLOW_BUILTIN=*

# Возвращаемся к стандартному пользователю node
USER node
