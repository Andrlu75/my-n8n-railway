# Базовый образ — на вашей версии n8n
FROM n8nio/n8n:1.108.1

USER root
# Устанавливаем пакет прямо в установку n8n
# Это и есть тот самый каталог, где у n8n лежит своё node_modules
RUN cd /usr/local/lib/node_modules/n8n \
 && npm install --omit=dev officeparser \
 && npm cache clean --force

# (необязательно, но полезно) Проверка на этапе билда:
RUN node -e "console.log('officeparser path =', require.resolve('officeparser'))"

# Разрешаем Code-нoде использовать внешний пакет и стандартные модули Node
ENV NODE_FUNCTION_ALLOW_EXTERNAL=officeparser
ENV NODE_FUNCTION_ALLOW_BUILTIN=*

USER node
