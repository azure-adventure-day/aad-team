FROM ghcr.io/azure-adventure-day/azure-adventure-day-coach/node:8.2.0-alpine

# copy sources
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY . .
RUN npm install

EXPOSE 3000
ENV PORT=3000

# start game bot via node command
CMD ["/bin/sh", "startgamebot.sh"]

