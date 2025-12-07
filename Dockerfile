FROM node:18-bullseye

# Ortam değişkenleri
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=4096
ENV COREPACK_ENABLE_STRICT=0

WORKDIR /app

# pnpm aktif et (Node 18'de corepack stabil çalışıyor)
RUN corepack enable

# Monorepo root'u kopyalıyoruz
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml ./

# Workspace bağımlılık dosyalarını kopyalıyoruz
COPY apps/backend/package.json ./apps/backend/
COPY apps/frontend/package.json ./apps/frontend/
COPY apps/workers/package.json ./apps/workers/
COPY apps/cron/package.json ./apps/cron/

# Tüm node_modules kurulur
# (lockfile hatasını çözmek için frozen-lockfile KULLANMIYORUZ)
RUN pnpm install --no-frozen-lockfile

# Kodun tamamını kopyala
COPY . .

# Build – düşük concurrency (RAM dostu)
RUN pnpm -r \
  --workspace-concurrency=1 \
  --filter ./apps/backend \
  --filter ./apps/frontend \
  --filter ./apps/workers \
  --filter ./apps/cron \
  run build

# pm2 global
RUN npm install -g pm2@5

# Uygulama start script
CMD ["pnpm", "run", "pm2-run"]
