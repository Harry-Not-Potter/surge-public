#!/bin/bash

# tree_with_ignore.sh - с игнорированием папок

# Список папок для исключения
EXCLUDE_DIRS=(".git" "build" "cmake-build-debug" "cmake-build-release" "node_modules" "__pycache__" ".idea" ".vscode")

show_tree_filtered() {
    local dir="${1:-.}"
    local prefix="${2:-}"
    local is_last="${3:-false}"
    
    # Получаем список, исключая скрытые и игнорируемые папки
    local items=()
    while IFS= read -r -d '' item; do
        local name=$(basename "$item")
        local skip=false
        
        # Проверяем, не входит ли папка в список исключений
        for exclude in "${EXCLUDE_DIRS[@]}"; do
            if [ "$name" = "$exclude" ]; then
                skip=true
                break
            fi
        done
        
        if [ "$skip" = false ]; then
            items+=("$item")
        fi
    done < <(find "$dir" -maxdepth 1 -mindepth 1 -not -path "*/\.*" -print0 | sort -z)
    
    local count=${#items[@]}
    local i=0
    
    for item in "${items[@]}"; do
        ((i++))
        local current_last=false
        if [ $i -eq $count ]; then
            current_last=true
        fi
        
        local name=$(basename "$item")
        
        if [ "$is_last" = true ]; then
            echo -n "${prefix}    "
        else
            echo -n "${prefix}│   "
        fi
        
        if [ "$current_last" = true ]; then
            echo -n "└── "
        else
            echo -n "├── "
        fi
        
        if [ -d "$item" ]; then
            echo "$name/"
            if [ "$is_last" = true ]; then
                show_tree_filtered "$item" "${prefix}    " "$current_last"
            else
                show_tree_filtered "$item" "${prefix}│   " "$current_last"
            fi
        else
            # Определяем тип файла по расширению
            case "$name" in
                *.cpp|*.c|*.h|*.hpp|*.cxx) echo -e "\033[36m$name\033[0m" ;;  # Синий
                *.py|*.pyc) echo -e "\033[33m$name\033[0m" ;;                   # Желтый
                *.md|*.txt|*.rst) echo -e "\033[32m$name\033[0m" ;;            # Зеленый
                *.json|*.xml|*.yaml|*.yml) echo -e "\033[35m$name\033[0m" ;;   # Фиолетовый
                *.sh|*.bash) echo -e "\033[31m$name\033[0m" ;;                 # Красный
                *) echo "$name" ;;
            esac
        fi
    done
}

# Использование
echo "."
show_tree_filtered "${1:-.}" "" true