# Daha stabil build için Debian slim image
FROM node:20-slim

# Ortak ayarlar
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=4096
ENV COREPACK_ENABLE_STRICT=0

WORKDIR /app

# pnpm aktif et
RUN corepack enable

# Sadece package.json ve pnpm-lock.yaml dosyalarını kopyala
COPY pnpm-lock.yaml ./
COPY package.json ./
COPY pnpm-workspace.yaml ./

# Workspace package.json dosyalarını kopyala
COPY apps/backend/package.json ./apps/backend/
COPY apps/frontend/package.json ./apps/frontend/
COPY apps/workers/package.json ./apps/workers/
COPY apps/cron/package.json ./apps/cron/
COPY libraries ./libraries

# Modülleri kur
RUN pnpm install --frozen-lockfile

# Tüm kaynak kodunu kopyala
COPY . .

# Build — concurrency düşük tutuldu
RUN pnpm -r --workspace-concurrency=1 \
  --filter "./apps/backend" \
  --filter "./apps/frontend" \
  --filter "./apps/workers" \
  --filter "./apps/cron" \
  run build

# Uygulamayı başlat
CMD ["pnpm", "run", "start:prod"]
