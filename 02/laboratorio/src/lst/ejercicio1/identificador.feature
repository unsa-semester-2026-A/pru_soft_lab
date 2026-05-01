Característica: Validación de Identificadores (Reglas de Fortran)

  Como compilador o intérprete
  Quiero validar los nombres de las variables
  Para asegurar que cumplan con las reglas de identificadores válidos

  Escenario: Validar longitud permitida de 1 a 6 caracteres
    Dado un identificador con longitud 1 como "A"
    Cuando se valida el identificador
    Entonces el resultado debe ser válido

  Escenario: Rechazar longitud no permitida
    Dado un identificador con longitud 7 como "A123456"
    Cuando se valida el identificador
    Entonces el resultado debe ser inválido

  Escenario: Validar que empiece obligatoriamente con una letra
    Dado un identificador "1ABC"
    Cuando se valida el identificador
    Entonces el resultado debe ser inválido
    
  Escenario: Rechazar caracteres especiales
    Dado un identificador "A#B"
    Cuando se valida el identificador
    Entonces el resultado debe ser inválido
