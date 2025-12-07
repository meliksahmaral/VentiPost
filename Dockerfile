FROM node:18-bullseye

# Ortam ayarları
ENV NODE_ENV=production
ENV NODE_OPTIONS=--max_old_space_size=4096
ENV COREPACK_ENABLE_STRICT=0

WORKDIR /app

# pnpm aktif et
RUN corepack enable

# Tüm repo içeriğini kopyala (schema.prisma dahil HER ŞEY)
COPY . .

# Tüm node_modules kurulur
RUN pnpm install --no-frozen-lockfile

# Build - düşük concurrency (RAM dostu)
RUN pnpm -r \
  --workspace-concurrency=1 \
  --filter ./apps/backend \
  --filter ./apps/frontend \
  --filter ./apps/workers \
  --filter ./apps/cron \
  run build

# Uygulama start script (repo’daki scripti kullanıyoruz)
CMD ["pnpm", "run", "pm2-run"]
