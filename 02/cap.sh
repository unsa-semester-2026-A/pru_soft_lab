#!/usr/bin/env bash

# Verificar que haya al menos 2 argumentos
if [ "$#" -lt 2 ]; then
    echo "Usage: capture.sh <output-file> <command1> [command2] [...]"
    echo "Example: ./capture.sh out 'exa -lah' 'cat sample.c'"
    exit 1
fi

output_file="$1"
shift # Remueve el primer argumento; ahora "$@" contiene solo los comandos
commands=("$@")

# Definición de colores ANSI
reset="\033[0m"
green="\033[38;5;114m"
blue="\033[38;5;111m"
flamingo="\033[38;5;217m"

# Crear archivo temporal
temp_output=$(mktemp)

# Iterar sobre cada comando
for cmd in "${commands[@]}"; do
    # Extraer la primera palabra y el resto usando expansión de parámetros
    first_word="${cmd%% *}"
    rest_words="${cmd#* }"

    # Construir el comando coloreado
    if [[ "$first_word" == "$cmd" ]]; then
        # Si no hay espacios, es un comando de una sola palabra
        colored_command="${blue}${first_word}${reset}"
    else
        colored_command="${blue}${first_word}${reset} ${flamingo}${rest_words}${reset}"
    fi

    # Escribir el prompt en el archivo temporal (%b interpreta los códigos ANSI)
    printf "%b❯ %b\n" "$green" "$colored_command" >> "$temp_output"
    
    # Ejecutar el comando y redirigir stdout y stderr al archivo temporal
    eval "$cmd" >> "$temp_output" 2>&1
done

# Pasar toda la salida a freeze
cat "$temp_output" | tee lascmd.log | freeze \
    --width 1000 \
    --theme catppuccin-mocha \
    --font.family "CaskaydiaMono Nerd Font" \
    --output "${output_file}.svg" \
    --language ansi

# Convertir SVG a PNG con Inkscape y limpiar
inkscape -w 2048 "${output_file}.svg" -o "${output_file}.png"
rm "${output_file}.svg"
rm "$temp_output"
