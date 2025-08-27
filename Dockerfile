FROM n8nio/n8n:1.108.1

USER root

# 1) Ставим officeparser во временный проект (с зависимостями)
RUN set -eux; \
    mkdir -p /opt/n8n-extra && cd /opt/n8n-extra && \
    npm init -y >/dev/null 2>&1 && \
    npm install --omit=dev officeparser

# 2) Пути назначения
ENV N8N_MAIN_NODEMOD="/usr/local/lib/node_modules/n8n/node_modules"
ENV N8N_PNPM_BASE="/usr/local/lib/node_modules/n8n/node_modules/.pnpm"

# 3) Копируем пакет и все его зависимости в основной процесс n8n
RUN set -eux; \
    mkdir -p "$N8N_MAIN_NODEMOD"; \
    cp -R /opt/n8n-extra/node_modules/* "$N8N_MAIN_NODEMOD"/

# 4) Копируем и в task-runner (чтобы Code-ноды тоже видели)
RUN set -eux; \
    TR_FOLDER="$(ls -1 "$N8N_PNPM_BASE" | grep '^@n8n+task-runner@' | head -n1)"; \
    mkdir -p "$N8N_PNPM_BASE/$TR_FOLDER/node_modules"; \
    cp -R /opt/n8n-extra/node_modules/* "$N8N_PNPM_BASE/$TR_FOLDER/node_modules"/

# 5) Проверка резолва
RUN node -e "module.paths.unshift(process.env.N8N_MAIN_NODEMOD); console.log('resolved:', require.resolve('officeparser'))"

# 6) Чистка и права
RUN rm -rf /opt/n8n-extra /root/.npm && \
    chown -R node:node "$N8N_MAIN_NODEMOD"

USER node

# Разрешаем Code-ноде использовать модуль
ENV NODE_FUNCTION_ALLOW_EXTERNAL=officeparser
ENV NODE_FUNCTION_ALLOW_BUILTIN=*

