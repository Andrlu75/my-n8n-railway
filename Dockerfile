# Используем вашу версию n8n в качестве базового образа (например, 1.108.1)
FROM n8nio/n8n:1.108.1

# Переключаемся на пользователя root для выполнения установки в системную директорию
USER root

# Переходим в директорию установки n8n и устанавливаем officeparser.
# Это критически важный шаг, так как нода "Code" ищет модули только здесь.
RUN cd /usr/local/lib/node_modules/n8n \
 && npm install --omit=dev officeparser \
 && npm cache clean --force

# (Опционально, но рекомендуется) Проверка на этапе сборки, что модуль найден
RUN cd /usr/local/lib/node_modules/n8n && node -e "console.log('officeparser path:', require.resolve('officeparser'))"

# Переключаемся обратно на стандартного пользователя n8n
USER node
