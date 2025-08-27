FROM n8nio/n8n:1.108.1

USER root

# 1) Ставим officeparser во временный проект
RUN set -eux; \
    mkdir -p /opt/n8n-extra && cd /opt/n8n-extra && \
    npm init -y >/dev/null 2>&1 && \
    npm install --omit=dev officeparser

# Пути
ENV N8N_ROOT="/usr/local/lib/node_modules/n8n"
ENV N8N_MAIN_NODEMOD="$N8N_ROOT/node_modules"
ENV N8N_PNPM_BASE="$N8N_MAIN_NODEMOD/.pnpm"

# 2) Вендорим пакет И его deps внутрь него самого (для ОСНОВНОГО процесса)
RUN set -eux; \
    # a) сам пакет
    rm -rf "$N8N_MAIN_NODEMOD/officeparser"; \
    mkdir -p "$N8N_MAIN_NODEMOD"; \
    cp -R /opt/n8n-extra/node_modules/officeparser "$N8N_MAIN_NODEMOD/"; \
    # b) его зависимости -> внутрь officeparser/node_modules (кроме самого officeparser)
    mkdir -p "$N8N_MAIN_NODEMOD/officeparser/node_modules"; \
    for d in /opt/n8n-extra/node_modules/*; do \
      b="$(basename "$d")"; \
      if [ "$b" != "officeparser" ]; then \
        cp -R "$d" "$N8N_MAIN_NODEMOD/officeparser/node_modules/" || true; \
      fi; \
    done

# 3) То же самое — для TASK RUNNER (чтобы Code-ноды тоже видели)
RUN set -eux; \
    TR_FOLDER="$(ls -1 "$N8N_PNPM_BASE" | grep '^@n8n+task-runner@' | head -n1)"; \
    TR_NODEMOD="$N8N_PNPM_BASE/$TR_FOLDER/node_modules"; \
    mkdir -p "$TR_NODEMOD"; \
    rm -rf "$TR_NODEMOD/officeparser"; \
    cp -R /opt/n8n-extra/node_modules/officeparser "$TR_NODEMOD/"; \
    mkdir -p "$TR_NODEMOD/officeparser/node_modules"; \
    for d in /opt/n8n-extra/node_modules/*; do \
      b="$(basename "$d")"; \
      if [ "$b" != "officeparser" ]; then \
        cp -R "$d" "$TR_NODEMOD/officeparser/node_modules/" || true; \
      fi; \
    done

# 4) Проверка резолва в основном процессе
RUN node -e "module.paths.unshift(process.env.N8N_MAIN_NODEMOD); console.log('resolved:', require.resolve('officeparser'))"

# 5) Чистка и права
RUN rm -rf /opt/n8n-extra /root/.npm && \
    chown -R node:node "$N8N_MAIN_NODEMOD"

# Разрешаем Code-нoде внешний пакет/билтины
ENV NODE_FUNCTION_ALLOW_EXTERNAL=officeparser
ENV NODE_FUNCTION_ALLOW_BUILTIN=*

USER node
