#!/bin/bash

# Nombre del archivo donde se guardará todo el contexto
ARCHIVO_SALIDA="contexto_para_ia.txt"

# Vaciar el archivo si ya existe de una ejecución anterior
> "$ARCHIVO_SALIDA"

# 1. GENERAR LA ESTRUCTURA DEL DIRECTORIO
echo "========================================" >> "$ARCHIVO_SALIDA"
echo "ESTRUCTURA DEL DIRECTORIO" >> "$ARCHIVO_SALIDA"
echo "========================================" >> "$ARCHIVO_SALIDA"

# Usar 'tree' si está instalado, ignorando .git y el archivo de salida
if command -v tree &> /dev/null; then
    tree -a -I ".git|$ARCHIVO_SALIDA" >> "$ARCHIVO_SALIDA"
else
    # Alternativa básica si 'tree' no está instalado
    echo "(Comando 'tree' no encontrado. Mostrando lista plana):" >> "$ARCHIVO_SALIDA"
    find . -not -path "*/\.git/*" -not -name "$ARCHIVO_SALIDA" | sort >> "$ARCHIVO_SALIDA"
fi

echo -e "\n\n" >> "$ARCHIVO_SALIDA"

# 2. PROCESAR EL CONTENIDO DE LOS ARCHIVOS
echo "========================================" >> "$ARCHIVO_SALIDA"
echo "CONTENIDO DE ARCHIVOS" >> "$ARCHIVO_SALIDA"
echo "========================================" >> "$ARCHIVO_SALIDA"

# Buscar todos los archivos regulares, excluyendo .git y el propio archivo de salida
find . -type f -not -path "*/\.git/*" -not -name "$ARCHIVO_SALIDA" | sort | while read -r ARCHIVO; do
    
    # Obtener ruta absoluta y codificación MIME
    RUTA_ABSOLUTA=$(realpath "$ARCHIVO")
    CODIFICACION=$(file -b --mime-encoding "$ARCHIVO")
    TIPO_MIME=$(file -b --mime-type "$ARCHIVO")

    if [[ "$CODIFICACION" != "binary" ]]; then
        # Es texto o código, adjuntamos el contenido
        echo "----------------------------------------" >> "$ARCHIVO_SALIDA"
        echo "ARCHIVO: $ARCHIVO" >> "$ARCHIVO_SALIDA"
        echo "RUTA ABSOLUTA: $RUTA_ABSOLUTA" >> "$ARCHIVO_SALIDA"
        echo "----------------------------------------" >> "$ARCHIVO_SALIDA"
        cat "$ARCHIVO" >> "$ARCHIVO_SALIDA"
        echo -e "\n\n" >> "$ARCHIVO_SALIDA" # Separador para el siguiente archivo
    else
        # Es un archivo binario (imagen, pdf, etc.), omitimos el contenido
        echo "----------------------------------------" >> "$ARCHIVO_SALIDA"
        echo "ARCHIVO OMITIDO: $ARCHIVO (Tipo: $TIPO_MIME, Binario)" >> "$ARCHIVO_SALIDA"
        echo "----------------------------------------" >> "$ARCHIVO_SALIDA"
        echo -e "\n" >> "$ARCHIVO_SALIDA"
    fi
done

echo "Proceso finalizado. El contexto completo se ha guardado en: $ARCHIVO_SALIDA"
