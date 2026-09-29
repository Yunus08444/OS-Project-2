#!/bin/bash

# Проверяем количество аргументов
if [ $# -lt 2 ] || [ $# -gt 4 ]; then
    echo "Usage: ./report.sh <directory> <ERROR|WARN> [--top N]" >&2
    exit 1
fi

DIRECTORY="$1"
LEVEL="$2"

# Проверяем уровень
if [ "$LEVEL" != "ERROR" ] && [ "$LEVEL" != "WARN" ]; then
    echo "Error: level must be ERROR or WARN" >&2
    exit 1
fi

# Проверяем каталог
if [ ! -d "$DIRECTORY" ]; then
    echo "Error: directory does not exist" >&2
    exit 1
fi

# Проверяем --top N
TOP=""

if [ $# -eq 4 ]; then
    if [ "$3" != "--top" ]; then
        echo "Usage: ./report.sh <directory> <ERROR|WARN> [--top N]" >&2
        exit 1
    fi

    if ! [[ "$4" =~ ^[0-9]+$ ]]; then
        echo "Error: N must be a number" >&2
        exit 1
    fi

    TOP="$4"
elif [ $# -eq 3 ]; then
    echo "Usage: ./report.sh <directory> <ERROR|WARN> [--top N]" >&2
    exit 1
fi

# Считаем количество сообщений каждого модуля
RESULT=$(grep -h "$LEVEL" "$DIRECTORY"/*.log 2>/dev/null |
    awk '{count[$3]++} END {for (module in count) print module, count[module]}' |
    sort -k2,2nr)

# Заголовок
echo "Модуль    Количество"

# Вывод
if [ -n "$TOP" ]; then
    echo "$RESULT" | head -n "$TOP"
else
    echo "$RESULT"
fi
