FROM node:15.8.0-alpine3.10

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000
CMD [ "node", "index.js" ]
ENTRYPOINT ["tail", "-f", "/dev/null"]