FROM node:20-alpine

# Daha rahat build için ayarlar
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=3072
ENV COREPACK_ENABLE_STRICT=0

WORKDIR /app

# pnpm aktif et
RUN corepack enable

# Tüm repo içeriğini kopyala
COPY . .

# Dependenceleri kur
RUN pnpm install --frozen-lockfile

# Build – concurrency düşük, Node heap büyük
RUN pnpm -r --workspace-concurrency=1 \
  --filter ./apps/frontend \
  --filter ./apps/backend \
  --filter ./apps/workers \
  --filter ./apps/cron \
  run build

# Uygulamayı başlat (gitroom package.json'daki script)
CMD ["pnpm", "run", "pm2-run"]
