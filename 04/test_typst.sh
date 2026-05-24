#!/bin/bash
cd /home/alvaro9rqc/1_Pacha/1-unsa/7_S/ps/lab/04
echo '#import "informe/util/util.typ": codeBlock
#codeBlock("/informe/src/lst/er1/pom.xml", lang: "xml")' > test.typ
typst compile test.typ
