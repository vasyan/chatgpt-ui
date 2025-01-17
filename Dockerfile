FROM node:18-alpine3.16 as node_deps

WORKDIR /app

COPY package.json ./

RUN npm install


FROM node:18-alpine3.16 as builder

WORKDIR /app

COPY --from=node_deps /app/node_modules ./node_modules
COPY --from=node_deps /app/package.json ./node_modules
COPY . .

RUN npm run build


FROM node:18-alpine3.16

ENV NITRO_PORT=80

WORKDIR /app

COPY --from=builder /app/.output/ .

EXPOSE 80

# TODO: You can use NITRO_PRESET=node_cluster in order to leverage multi-process performance using Node.js cluster module. https://nuxt.com/docs/getting-started/deployment

ENTRYPOINT ["node", "server/index.mjs"]