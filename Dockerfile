FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache git

USER node
RUN cd /home/node/.n8n/ && npm install officeparser
