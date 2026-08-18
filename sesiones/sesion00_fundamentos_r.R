# =============================================================================
# Sesión 0 — Fundamentos de R: aritmética, variables y ayuda
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Primer contacto con la sintaxis de R: operaciones aritméticas, variables,
#   tipos de datos, un primer vistazo a vectores, operadores de comparación,
#   cómo usar la ayuda/documentación integrada, e instalar/cargar librerías
#   (paquetes). La sesión 1 retoma vectores y tipos de datos con mayor
#   profundidad y a mayor ritmo.

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
# 6. Operadores de comparación
# -----------------------------------------------------------------------------

5 == 5      # igualdad (no confundir con <-, que es asignación)
5 != 3      # distinto
5 > 3
5 >= 5
3 < 5
!TRUE       # negación

# También se aplican a vectores completos, elemento por elemento:
edades > 25

# Combinar condiciones: & (y), | (o)
edades > 22 & edades < 30

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
# R base trae muchas funciones (mean, sum, class...), pero la mayor parte de
# su poder está en paquetes: colecciones de funciones adicionales que
# instalas una vez y cargas cada sesión. CRAN (Comprehensive R Archive
# Network) es el repositorio oficial de paquetes.

# install.packages() descarga e instala un paquete desde CRAN.
# Solo se hace UNA VEZ por computadora (no en cada sesión):
# install.packages("tidyverse")

# library() carga un paquete YA instalado en la sesión actual. A diferencia
# de install.packages(), esto sí hay que hacerlo cada vez que abres R:
# library(tidyverse)

# Ver qué paquetes ya tienes instalados:
installed.packages()[, "Package"] |> head(10)

# require() hace lo mismo que library(), pero regresa FALSE en vez de dar
# error si el paquete no existe — útil dentro de funciones/scripts que
# necesitan comprobar si algo está disponible antes de usarlo.
# if (!require("tidyverse")) install.packages("tidyverse")

# En este curso, install.R (en la raíz del proyecto) ya instala de una vez
# todos los paquetes necesarios: basta correr source("install.R") al inicio.

# =============================================================================
# EJERCICIO
# =============================================================================

# Crea un vector `temperaturas` con las temperaturas (en °C) de 7 días de
# la semana. Calcula:
#   a) la temperatura promedio de la semana
#   b) cuántos días la temperatura fue mayor a 25°C
#   c) un vector lógico que indique en qué días la temperatura estuvo
#      entre 20°C y 28°C (inclusive)

# =============================================================================
# SOLUCIÓN AL EJERCICIO
# =============================================================================

temperaturas <- c(22, 25, 28, 19, 31, 24, 27)

# a) Temperatura promedio
promedio <- mean(temperaturas)
promedio

# b) Días con más de 25°C
sum(temperaturas > 25)          # sum() sobre un lógico cuenta los TRUE

# c) Días entre 20°C y 28°C (inclusive)
temperaturas >= 20 & temperaturas <= 28
