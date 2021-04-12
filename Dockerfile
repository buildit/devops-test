FROM node:15.13.0-slim

RUN mkdir /app

COPY package.json package.json

# RUN npm install

# COPY . .

LABEL maintainer="Kanmi Durotoye"

# CMD node index.js


RUN npm install

ENTRYPOINT npm run start