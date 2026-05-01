# language: es

Característica: Retiro en Cajero Automático (ATM)
  Como usuario del banco
  Quiero intentar retirar dinero del cajero
  Para que el sistema me proteja si no tengo saldo suficiente

  Escenario: Retiro fallido por fondos insuficientes <- PRINCIPAL
    Dado que mi saldo es 100
    Cuando intento retirar 150
    Entonces debo ver el mensaje "Fondos Insuficientes"
    Y mi saldo restante debe ser 100

  Escenario: Retiro exitoso con saldo suficiente
    Dado que mi saldo es 100
    Cuando intento retirar 50
    Entonces debo ver el mensaje "Retiro exitoso"

  Escenario: Retiro con monto exacto al saldo (valor límite)
    Dado que mi saldo es 100
    Cuando intento retirar 100
    Entonces debo ver el mensaje "Retiro exitoso"

  Escenario: Retiro de monto cero (valor inválido)
    Dado que mi saldo es 100
    Cuando intento retirar 0
    Entonces debo ver el mensaje "Monto inválido"
