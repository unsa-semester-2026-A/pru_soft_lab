#!/bin/bash
# rectangle_test.sh - Forma 1

echo "========================================"
echo "📏 TEST: area del rectangulo (Unittest)"
echo "========================================"

# Ejecutamos el test unitario en modo verbose
python3 ./rectangle_test.py -v
# python3 ./01/laboratorio/src/lst/rectangle_test.py -v

if [ $? -eq 0 ]; then
    echo -e "\n✅ RESULTADO: El codigo paso todas las pruebas unitarias."
else
    echo -e "\n❌ RESULTADO: Se encontraron errores en el calculo."
    exit 1
fi