# Capítulo 0 — Fundamentos de R: aritmética, variables y ayuda

**Sesión 0 · 2 horas** — primer contacto con la sintaxis de R
Preparación previa: [guía de instalación](../instalacion.md)
Script de práctica: [`sesiones/sesion00_fundamentos_r.R`](../../sesiones/sesion00_fundamentos_r.R)

[Índice](../../README.md) · [Capítulo 1 →](capitulo01_vectores_tipos.md)

## Objetivo

Este capítulo es el punto de entrada más básico del curso: aritmética, variables, tipos de datos, un primer vistazo a vectores, operadores de comparación y lógicos, cómo usar la ayuda integrada de R, e instalar/cargar librerías. El [capítulo 1](capitulo01_vectores_tipos.md) retoma vectores y tipos de datos con más profundidad y a mayor ritmo — si ya tienes experiencia programando, puedes avanzar directo a ese capítulo y usar este como referencia.

## 1. Operaciones aritméticas

R funciona como calculadora desde la consola, con el orden de operaciones habitual:

```r
2 + 3
10 - 4
6 * 7
20 / 4
2^10          # potencia
17 %% 5       # módulo (residuo de la división)
17 %/% 5      # división entera

(2 + 3) * 4   # los paréntesis funcionan como en cualquier lenguaje
```

`%%` y `%/%` son operadores propios de R que no siempre existen con ese símbolo en otros lenguajes — el residuo y el cociente entero de una división.

## 2. Variables

`<-` es el operador de asignación preferido en R (aunque `=` también funciona).

```r
x <- 10
y <- 5
x + y

x <- x + 1   # reasignar es válido en cualquier momento
x
```

Los nombres de variable pueden llevar letras, números, `.` y `_`, pero no pueden empezar con número ni coincidir con una palabra reservada (`TRUE`, `if`, `for`, ...). A diferencia de muchos lenguajes, en R **el punto es un carácter válido** dentro de un nombre:

```r
mi_variable <- 1
mi.variable <- 2
```

Dos funciones útiles para administrar tu sesión:

```r
ls()             # qué variables existen en tu sesión
rm(mi.variable)  # eliminar una variable
```

## 3. Tipos de datos

```r
class(10)          # "numeric" (double)
class(10L)         # "integer"
class("hola")      # "character"
class(TRUE)        # "logical"
class(NA)          # "logical" por default

is.numeric(10)
is.character("hola")
```

## 4. Vectores: primer contacto

Un vector es una colección ordenada de valores del mismo tipo, y se crea con `c()` ("combine"). Este capítulo solo los presenta; el [capítulo 1](capitulo01_vectores_tipos.md) profundiza en indexación y vectorización.

```r
edades <- c(23, 25, 22, 30, 27)
edades

nombres <- c("Ana", "Luis", "Carla")
nombres
```

## 5. Operaciones con vectores

Las operaciones aritméticas se aplican a **todo el vector a la vez** — esto se llama vectorización, y es uno de los rasgos que más distingue a R de lenguajes de propósito general.

```r
edades + 1          # cumpleaños de todos
edades * 2
sum(edades)
mean(edades)
max(edades); min(edades)
```

## 6. Operadores de comparación y operadores lógicos

```r
5 == 5      # igualdad (no confundir con <-, que es asignación)
5 != 3      # distinto
5 > 3
5 >= 5
3 < 5
!TRUE       # negación
```

También se aplican a vectores completos, elemento por elemento, y se pueden combinar con `&` (y) / `|` (o):

```r
edades > 25
edades > 22 & edades < 30
```

`&` y `|` son **vectorizados**: comparan posición por posición y regresan un vector completo. `&&` y `||` son **escalares**: solo miran el primer elemento de cada lado y regresan un único `TRUE`/`FALSE`. Se usan casi siempre dentro de `if()`/`while()`, donde necesitas una sola condición, no un vector:

```r
edad <- 25
edad > 18 && edad < 65      # un solo TRUE/FALSE -> válido en if()

if (edad > 18 && edad < 65) {
  print("edad válida")
}
```

`&&` y `||` tienen *corto-circuito* (short-circuit): si el primer lado ya decide el resultado, el segundo ni se evalúa. Esto es útil para evitar errores en cadena:

```r
x <- NULL
if (!is.null(x) && x > 0) {
  print("x es positivo")
}   # is.null(x) es TRUE -> !is.null(x) es FALSE -> nunca se evalúa x > 0
```

Otras funciones lógicas de uso frecuente:

```r
xor(TRUE, FALSE)    # "o exclusivo": TRUE solo si exactamente una es TRUE
xor(TRUE, TRUE)      # FALSE

any(edades > 28)    # TRUE si AL MENOS UNA edad es mayor a 28
all(edades > 20)    # TRUE si TODAS las edades son mayores a 20

isTRUE(5 > 3)       # comprueba que el valor sea EXACTAMENTE TRUE
isTRUE(NA)          # FALSE, sin error (a diferencia de NA == TRUE)
```

`any()`/`all()` son el puente natural entre un vector lógico (resultado de `&`/`|`) y una sola condición usable en `if()` — muy parecido a lo que hace `sum()` sobre un lógico, pero regresando `TRUE`/`FALSE` en vez de un conteo.

## 7. Elementos de un vector

R indexa desde 1, no desde 0 — la primera de muchas diferencias con lenguajes como Python o C que verás a lo largo del curso.

```r
edades[1]           # primer elemento
edades[c(1, 3)]      # primero y tercero
edades[edades > 25]  # indexación lógica
```

## 8. Ayuda y documentación

R trae documentación integrada para prácticamente cualquier función — no necesitas salir de RStudio para consultarla.

```r
?mean               # abre la página de ayuda de mean() en el panel Help
help("mean")        # equivalente a lo anterior

args(mean)           # qué argumentos acepta la función
example(mean)         # corre los ejemplos de la documentación

??"media"            # busca en toda la documentación instalada
```

`?` es tu primer recurso cuando no sabes qué argumentos acepta una función; `??` cuando ni siquiera sabes cómo se llama la función que buscas.

## 9. Instalar y cargar librerías (paquetes)

R base trae muchas funciones (`mean`, `sum`, `class`...), pero la mayor parte de su poder está en **paquetes**: colecciones de funciones adicionales que instalas una vez y cargas cada sesión. **CRAN** (*Comprehensive R Archive Network*) es el repositorio oficial de paquetes de R.

```r
# install.packages() descarga e instala un paquete desde CRAN.
# Se hace UNA SOLA VEZ por computadora, no en cada sesión:
install.packages("tidyverse")

# library() carga un paquete YA instalado en la sesión actual.
# A diferencia de install.packages(), esto sí hay que hacerlo cada vez
# que abres R:
library(tidyverse)

# Ver qué paquetes ya tienes instalados:
installed.packages()[, "Package"] |> head(10)
```

`require()` hace lo mismo que `library()`, pero regresa `FALSE` en vez de dar error si el paquete no existe — útil dentro de funciones o scripts que necesitan comprobar disponibilidad antes de usar un paquete:

```r
if (!require("tidyverse")) install.packages("tidyverse")
```

En este curso no necesitas instalar paquetes uno por uno: [`install.R`](../../install.R), en la raíz del proyecto, ya instala de una vez todos los que se usan más adelante. Basta con correr `source("install.R")` al terminar la [guía de instalación](../instalacion.md).

## Ejercicio

Esta semana se registraron las siguientes temperaturas (°C), de lunes a domingo:

```r
temperaturas <- c(22, 25, 28, 19, 31, 24, 27)
```

Calcula:

a. la temperatura promedio de la semana
b. cuántos días la temperatura fue mayor a 25°C
c. un vector lógico que indique en qué días la temperatura estuvo entre 20°C y 28°C (inclusive)

Pista para el inciso (b): `sum()` sobre un vector lógico es un patrón que vas a repetir muchísimo en R — `TRUE` se trata como `1` y `FALSE` como `0`, así que sumar un vector lógico cuenta cuántos `TRUE` hay.

## Ejemplo: inventario de una tienda

Un ejemplo que combina vectores, aritmética, comparación y operadores lógicos en un solo problema con más de un paso — así se ve un mini-análisis real, aunque sea chiquito.

```r
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
```

Nota cómo `producto[stock > 0 & precio == precio_max_disponible]` combina **dos condiciones** dentro de la misma indexación lógica con `&`: solo te interesan los productos que tienen stock **y** cuyo precio coincide con el máximo encontrado. Combinar condiciones así, en vez de hacerlo en dos pasos separados, es un patrón que vas a usar todo el tiempo.

## Ejercicios

2. Un puesto de mercado tiene este catálogo y existencias:

   ```r
   articulo    <- c("manzana", "pan", "leche", "huevo", "queso")
   existencias <- c(12, 0, 5, 0, 8)
   ```

   Encuentra cuántos artículos están agotados (`existencias == 0`) y qué porcentaje del catálogo representan.

3. **Reto:** esta semana se registraron estos datos:

   ```r
   temperatura <- c(18, 22, 15, 19, 24, 17, 20)
   lluvia_mm   <- c(5, 0, 12, 3, 0, 8, 0)
   ```

   Encuentra en cuántos días llovió (`lluvia_mm > 0`) **y** la temperatura fue menor a 20°C, usando un solo operador lógico.

---

[Índice](../../README.md) · [Capítulo 1 →](capitulo01_vectores_tipos.md)
