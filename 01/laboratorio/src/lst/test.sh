#!/bin/bash

# Detectar el directorio donde está este script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "=========================================================="
echo "🚀 INICIANDO TODAS LAS PRUEBAS UNITARIAS"
echo "=========================================================="

# Contador de éxitos y fallos
EXITOS=0
FALLOS=0

# Buscar todos los archivos que terminan en _test.py en esta carpeta
for test_file in "./"*_test.py; do
    #1. Obtener solo el nombre del archivo para imprimirlo bonito
    filename=$(basename "$test_file")

    #2. Nombre del test
    FILENAME_UPPER=$(echo "$filename" | tr '[:lower:]' '[:upper:]')

    echo -e "\n🧪 EJECUTANDO TEST: $FILENAME_UPPER" 
    echo "----------------------------------------------------------"
    
    # Ejecutar el test
    python3 "$test_file" -v
    
    # Verificar si el último comando falló
    if [ $? -eq 0 ]; then
        ((EXITOS++))
    else
        ((FALLOS++))
    fi
done

echo -e "\n=========================================================="
echo "📊 RESUMEN FINAL:"
echo "✅ Pruebas exitosas: $EXITOS"
echo "❌ Pruebas fallidas: $FALLOS"
echo "=========================================================="

# Salir con error si hubo algún fallo (útil para CI/CD)
if [ $FALLOS -gt 0 ]; then
    exit 1
fi