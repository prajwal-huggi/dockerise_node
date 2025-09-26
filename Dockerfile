FROM node:18-bullseye AS builder

WORKDIR /app

COPY pakcage*.json ./

RUN npm ci --silent

COPY . .

RUN npm run build || true

RUN npm prune --production --silent

FROM node:18-slim AS runner

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/package*.json ./

COPY --from=builder /app/node_modules ./node_modules

COPY --from=builder /app/dist ./dist

EXPOSE 3000

CMD ["node", "dist/main.js"]