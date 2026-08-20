# =============================================================================
# Sesión 0 — Fundamentos de R: aritmética, variables y ayuda
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Primer contacto con la sintaxis de R: operaciones aritméticas, variables,
#   tipos de datos, un primer vistazo a vectores, operadores de comparación
#   y lógicos (&, |, &&, ||, xor, any, all), cómo usar la ayuda/documentación
#   integrada, e instalar/cargar librerías (paquetes). La sesión 1 retoma
#   vectores y tipos de datos con mayor profundidad y a mayor ritmo.

# -----------------------------------------------------------------------------
# 1. Operaciones aritméticas
# -----------------------------------------------------------------------------

2 + 3
10 - 4
6 * 7
20 / 4
2^10          # potencia
17 %% 5       # módulo (residuo de la división)
17 %/% 5      # división entera

# R respeta el orden de operaciones habitual y permite paréntesis
(2 + 3) * 4

# -----------------------------------------------------------------------------
# 2. Variables
# -----------------------------------------------------------------------------

x <- 10              # <- es el operador de asignación preferido en R
y <- 5
x + y

# Puedes reasignar una variable en cualquier momento
x <- x + 1
x

# Reglas de nombres: pueden llevar letras, números, "." y "_", pero no
# pueden empezar con número ni ser una palabra reservada (TRUE, if, for...)
mi_variable <- 1
mi.variable <- 2     # el punto es válido en R (a diferencia de otros lenguajes)

# Ver qué variables existen en tu sesión, y eliminarlas
ls()
rm(mi.variable)

# -----------------------------------------------------------------------------
# 3. Tipos de datos
# -----------------------------------------------------------------------------

class(10)          # "numeric" (double)
class(10L)         # "integer"
class("hola")      # "character"
class(TRUE)        # "logical"
class(NA)          # "logical" por default

# Puedes preguntar directamente si un objeto es de cierto tipo
is.numeric(10)
is.character("hola")

# -----------------------------------------------------------------------------
# 4. Vectores: primer contacto
# -----------------------------------------------------------------------------
# Un vector es una colección ordenada de valores del mismo tipo. Se crea
# con la función c() ("combine"). Los profundizaremos en la sesión 1.

edades <- c(23, 25, 22, 30, 27)
edades

nombres <- c("Ana", "Luis", "Carla")
nombres

# -----------------------------------------------------------------------------
# 5. Operaciones con vectores
# -----------------------------------------------------------------------------
# Las operaciones aritméticas se aplican a TODO el vector de una vez
# (esto se llama vectorización, y es el sello distintivo de R):

edades + 1          # cumpleaños de todos
edades * 2
sum(edades)
mean(edades)
max(edades); min(edades)

# -----------------------------------------------------------------------------
# 6. Operadores de comparación y operadores lógicos
# -----------------------------------------------------------------------------

5 == 5      # igualdad (no confundir con <-, que es asignación)
5 != 3      # distinto
5 > 3
5 >= 5
3 < 5
!TRUE       # negación

# También se aplican a vectores completos, elemento por elemento:
edades > 25

# Combinar condiciones: & (y), | (o) -- se aplican elemento por elemento
edades > 22 & edades < 30

# & y | son vectorizados; && y || son escalares y se usan en if()/while():
edad <- 25
edad > 18 && edad < 65      # un solo TRUE/FALSE -> válido en if()
# edades > 22 && edades < 30   # ERROR o warning: edades tiene varios elementos

if (edad > 18 && edad < 65) {
  print("edad válida")
}

# && y || tienen "corto-circuito": si el primer lado ya decide el resultado,
# el segundo ni se evalúa. Esto es útil para evitar errores en cadena:
x <- NULL
if (!is.null(x) && x > 0) {
  print("x es positivo")
}   # is.null(x) es TRUE -> !is.null(x) es FALSE -> nunca se evalúa x > 0

# xor(): "o exclusivo" -- TRUE solo si exactamente una de las dos es TRUE
xor(TRUE, FALSE)   # TRUE
xor(TRUE, TRUE)    # FALSE

# any()/all(): reducen un vector lógico a un solo TRUE/FALSE
any(edades > 28)    # TRUE si AL MENOS UNA edad es mayor a 28
all(edades > 20)    # TRUE si TODAS las edades son mayores a 20

# isTRUE()/isFALSE(): comprueban que un valor sea EXACTAMENTE TRUE/FALSE
# (más seguro que == TRUE cuando el valor podría ser NA o no lógico)
isTRUE(5 > 3)
isTRUE(NA)          # FALSE, no da error como NA == TRUE

# -----------------------------------------------------------------------------
# 7. Elementos de un vector
# -----------------------------------------------------------------------------
# R indexa desde 1, no desde 0.

edades[1]           # primer elemento
edades[c(1, 3)]      # primero y tercero
edades[edades > 25]  # indexación lógica

# -----------------------------------------------------------------------------
# 8. Ayuda y documentación
# -----------------------------------------------------------------------------
# R trae documentación integrada para prácticamente cualquier función.

?mean               # abre la página de ayuda de mean() en el panel Help
help("mean")        # equivalente a lo anterior

args(mean)           # muestra los argumentos que acepta la función
example(mean)         # corre los ejemplos de la documentación

# Cuando no recuerdas el nombre exacto de una función:
??"media"            # busca en toda la documentación instalada

# -----------------------------------------------------------------------------
# 9. Instalar y cargar librerías (paquetes)
# -----------------------------------------------------------------------------
# La mayor parte del poder de R está en paquetes (CRAN es el repositorio oficial).

# install.packages() descarga e instala un paquete desde CRAN.
# Solo se hace UNA VEZ por computadora (no en cada sesión):
# install.packages("tidyverse")

# library() carga un paquete YA instalado en la sesión actual. A diferencia
# de install.packages(), esto sí hay que hacerlo cada vez que abres R:
# library(tidyverse)

# Ver qué paquetes ya tienes instalados:
installed.packages()[, "Package"] |> head(10)

# require() es como library() pero regresa FALSE en vez de error:
# if (!require("tidyverse")) install.packages("tidyverse")

# En este curso, install.R (en la raíz del proyecto) ya instala de una vez
# todos los paquetes necesarios: basta correr source("install.R") al inicio.

# =============================================================================
# EJERCICIO
# =============================================================================

# Esta semana se registraron las siguientes temperaturas (°C), de lunes a
# domingo:
#   temperaturas <- c(22, 25, 28, 19, 31, 24, 27)
# Guárdalas en un vector `temperaturas` y calcula:
#   a) la temperatura promedio de la semana
#   b) cuántos días la temperatura fue mayor a 25°C
#   c) un vector lógico que indique en qué días la temperatura estuvo
#      entre 20°C y 28°C (inclusive)

# =============================================================================
# EJEMPLO: inventario de una tienda
# =============================================================================
# Combina vectores, aritmética, comparación y operadores lógicos en un solo
# problema con más de un paso -- así se ve un mini-análisis real.

producto <- c("playera", "pantalon", "gorra", "sudadera", "calcetines")
precio   <- c(250, 480, 150, 620, 60)
stock    <- c(12, 3, 25, 0, 40)

# Valor total del inventario (precio * cantidad, elemento por elemento)
valor_por_producto <- precio * stock
valor_por_producto
valor_total <- sum(valor_por_producto)
valor_total

# ¿Qué productos están por agotarse (stock < 5) pero SÍ tienen existencia
# (no están ya en 0)?
por_agotarse <- stock < 5 & stock > 0
producto[por_agotarse]

# ¿Cuál es el precio más alto entre los productos con stock disponible?
precio_max_disponible <- max(precio[stock > 0])
precio_max_disponible

# ¿Qué producto es? (indexación lógica combinando dos condiciones con &)
producto[stock > 0 & precio == precio_max_disponible]

# Sube el precio 10% a todo excepto a los calcetines (el último producto)
precio_nuevo <- precio
precio_nuevo[-5] <- precio_nuevo[-5] * 1.10
precio_nuevo

# =============================================================================
# EJERCICIOS
# =============================================================================

# 2. Un puesto de mercado tiene este catálogo y existencias:
#      articulo    <- c("manzana", "pan", "leche", "huevo", "queso")
#      existencias <- c(12, 0, 5, 0, 8)
#    Encuentra cuántos artículos están agotados (existencias == 0) y qué
#    porcentaje del catálogo representan.

# 3. (Reto) Esta semana se registraron estos datos:
#      temperatura <- c(18, 22, 15, 19, 24, 17, 20)
#      lluvia_mm   <- c(5, 0, 12, 3, 0, 8, 0)
#    Encuentra en cuántos días llovió (lluvia_mm > 0) Y la temperatura fue
#    menor a 20°C, usando un solo operador lógico.
