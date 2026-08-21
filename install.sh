#!/bin/bash

# Установка surge-public
set -e

echo "📦 Установка surge-public..."

# Скачиваем и устанавливаем последний .deb
curl -s https://api.github.com/repos/Harry-Not-Potter/surge-public/releases/latest | \
    grep "browser_download_url.*deb" | \
    cut -d '"' -f 4 | \
    wget -i - && \
    sudo dpkg -i *.deb && \
    sudo apt-get install -f -y

echo "✅ Установка завершена!"
rm -f *.deb  # Очистка
