# Base image: Node 20 + Alpine
FROM node:20-alpine

# pnpm için gerekli ortam değişkeni
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

# pnpm’i etkinleştir
RUN corepack enable

# pm2 global yükle
RUN npm install -g pm2

# Çalışma klasörü
WORKDIR /app

# Tüm proje dosyalarını container içine kopyala
COPY . .

# Dependency'leri yükle
RUN pnpm install --frozen-lockfile

# Build al (frontend + backend + workers + cron)
RUN pnpm build

# Production port
EXPOSE 5000

# PM2 ile projeyi başlat
CMD ["pnpm", "run", "pm2-run", "/app"]
