# Базовый образ вашей версии n8n
FROM n8nio/n8n:1.108.1

USER root

# Устанавливаем officeparser во временную папку и копируем модуль в n8n/node_modules
RUN set -eux; \
    mkdir -p /opt/n8n-extra && cd /opt/n8n-extra && \
    # Инициализируем временный проект
    npm init -y >/dev/null 2>&1 && \
    # Устанавливаем пакет в изоляции
    npm install --omit=dev officeparser && \
    # Убеждаемся, что целевая директория существует
    mkdir -p /usr/local/lib/node_modules/n8n/node_modules && \
    # Копируем установленный модуль в место, где его ищет нода "Code"
    cp -R node_modules/officeparser /usr/local/lib/node_modules/n8n/node_modules/ && \
    # Проверка резолва прямо на этапе билда
    node -e "module.paths.unshift('/usr/local/lib/node_modules/n8n/node_modules'); console.log('resolved:', require.resolve('officeparser'))"; \
    # Чистим временные файлы
    rm -rf /opt/n8n-extra /root/.npm

# Разрешаем Code-ноде использовать внешний пакет и стандартные модули Node
# (Их также можно установить через интерфейс Railway)
ENV NODE_FUNCTION_ALLOW_EXTERNAL=officeparser
ENV NODE_FUNCTION_ALLOW_BUILTIN=*

# Права на модуль — пользователю node
RUN chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/officeparser

USER node
