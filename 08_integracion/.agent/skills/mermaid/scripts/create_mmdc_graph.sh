#!/bin/sh
mmdc -i "$1" -o "${1%.*}.pdf" --pdfFit
