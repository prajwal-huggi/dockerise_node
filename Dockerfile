# Stage 1: Dependencies
FROM node:18-bullseye AS deps

WORKDIR /app

COPY package*.json ./

RUN npm ci --silent

# Stage 2: Runner
FROM node:18-slim AS runner

WORKDIR /app

ENV NODE_ENV=production

# Copy only the necessary parts
COPY --from=deps /app/node_modules ./node_modules
COPY . .

EXPOSE 3000

CMD ["node", "main.js"]
