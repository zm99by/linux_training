#!/usr/bin/env bash
set -e

cat <<'MSG'
🧪 Linux training

Задание:
  🔹 Найдите файл конфигурации приложения.
  🔹 Измените правильный порт (на 5432).
  🔹 Ой! Нет прав на запись?
  🔹 Исправьте права → измените порт → при необходимости верните права назад.
  🔹 После редактирования выполните: systemctl restart db

Подсказки:
  • Файл: /etc/application/db.conf
  • Посмотреть права: ls -l /etc/application/db.conf
  • Временно дать себе возможность редактировать: sudo chmod u+w /etc/application/db.conf
  • Редактор: nano /etc/application/db.conf

Удачи!
MSG

# Переходим в интерактивную оболочку
exec bash -l
