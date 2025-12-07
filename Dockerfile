FROM node:22.20-alpine

ARG NEXT_PUBLIC_VERSION
ENV NEXT_PUBLIC_VERSION=$NEXT_PUBLIC_VERSION

# Gerekli paketler
RUN apk add --no-cache g++ make py3-pip bash nginx

# Nginx için user ve klasörler
RUN adduser -D -g 'www' www
RUN mkdir /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www

# pnpm ve pm2'yi GLOBAL kur (resmi Postiz imajındaki gibi)
RUN npm --no-update-notifier --no-fund --global install pnpm@10.6.1 pm2

WORKDIR /app

# Tüm repo içeriğini kopyala
COPY . /app

# Nginx konfigürasyonunu kopyala
COPY var/docker/nginx.conf /etc/nginx/nginx.conf

# Dependenc’leri kur
RUN pnpm install

# Build (RAM dostu ayarla)
RUN NODE_OPTIONS="--max-old-space-size=4096" pnpm run build

# Container start: nginx + pm2
CMD ["sh", "-c", "nginx && pnpm run pm2"]
