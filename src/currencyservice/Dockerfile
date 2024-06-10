FROM node:20-alpine

RUN apk add python3 make g++

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm install

COPY . .

EXPOSE 7000

ENTRYPOINT ["node", "server.js" ]
