#!/bin/bash

# 1. Navegar a la raíz del proyecto basándose en la ubicación de este script,
# no en la raíz del repositorio de Git. (Sube un nivel desde 'scripts/')
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT" || exit 1

OUTPUT="ai_context.txt"
> "$OUTPUT"

echo "Generando contexto en $PROJECT_ROOT/$OUTPUT..."

# 2. git ls-files con filtro invertido (grep -v) para que ignore su propio archivo de salida
git ls-files -c -o --exclude-standard | grep -v "^$OUTPUT$" | while read -r file; do

  # Prevenir que intente leer directorios o archivos borrados
  if [ ! -f "$file" ]; then
    continue
  fi

  echo "==================================================" >> "$OUTPUT"
  echo "Archivo: $file" >> "$OUTPUT"
  echo "==================================================" >> "$OUTPUT"

  if echo "$file" | grep -iEq '\.(pdf|jpg|jpeg|png|gif|ico|zip|tar|gz|exe|dll|sqlite3|pyc|pyo|pyd)$'; then
    echo "[Contenido binario omitido por extensión]" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT"
    continue
  fi

  MIME_TYPE=$(file -b --mime-type "$file")

  if echo "$MIME_TYPE" | grep -qE '^text/|json|toml|xml|javascript|x-empty'; then
    cat "$file" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT"
  else
    echo "[Archivo no es texto plano ($MIME_TYPE). Contenido omitido]" >> "$OUTPUT"
    echo -e "\n" >> "$OUTPUT"
  fi
done

echo "Contexto generado exitosamente en: $OUTPUT"
