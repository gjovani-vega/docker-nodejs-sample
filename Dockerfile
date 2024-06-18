FROM node:20-alpine as builder
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .

FROM node:20-alpine as dev
WORKDIR /app
COPY --from=builder /app ./
CMD ["npm", "run", "dev"]

FROM node:20-alpine as prod
WORKDIR /app
COPY --from=builder /app ./
CMD ["node", "./src/index.js" ]
