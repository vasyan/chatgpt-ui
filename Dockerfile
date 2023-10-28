FROM node:18-alpine3.16 as node_deps

WORKDIR /app

COPY package.json yarn.lock ./

RUN yarn install


FROM node:18-alpine3.16 as builder

WORKDIR /app

COPY --from=builder /app/node_modules .
COPY --from=builder /app/package.json .
COPY . .

RUN yarn build


FROM node:18-alpine3.16

ENV NITRO_PORT=80

WORKDIR /app

COPY --from=builder /app/.output/ .

EXPOSE 80

# TODO: You can use NITRO_PRESET=node_cluster in order to leverage multi-process performance using Node.js cluster module. https://nuxt.com/docs/getting-started/deployment

ENTRYPOINT ["node", "server/index.mjs"]