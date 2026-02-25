# Sử dụng Node.js bản LTS
FROM node:18-slim

# Cài đặt các thư viện hệ thống cần thiết cho Puppeteer/Chrome
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    gconf-service \
    libasound2 \
    libatk1.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libgbm1 \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libglib2.0-0 \
    libgtk-3-0 \
    libnspr4 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    ca-certificates \
    libappindicator1 \
    nss-plugin-pem \
    lsb-release \
    xdg-utils \
    wget \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Tạo thư mục làm việc
WORKDIR /app

# Copy package.json và cài đặt thư viện Nodejs
COPY package*.json ./
RUN npm install

# Copy toàn bộ code vào container
COPY . .

# Railway sẽ tự động cung cấp PORT qua biến môi trường
ENV PORT=3000
EXPOSE 3000

# Lệnh chạy ứng dụng
CMD ["node", "index.js"]
