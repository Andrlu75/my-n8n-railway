FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache git

USER node
WORKDIR /usr/local/lib/node_modules/n8n
# Install the module ignoring peer dependency issues
RUN npm install officeparser --legacy-peer-deps
