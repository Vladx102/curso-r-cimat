# Capítulo 0 — Fundamentos de R: aritmética, variables y ayuda

**Sesión 0 · 2 horas** — primer contacto con la sintaxis de R
Preparación previa: [guía de instalación](../instalacion.md)
Script de práctica: [`sesiones/sesion00_fundamentos_r.R`](../../sesiones/sesion00_fundamentos_r.R)

[Índice](../../README.md) · [Capítulo 1 →](capitulo01_vectores_tipos.md)

## Objetivo

Este capítulo es el punto de entrada más básico del curso: aritmética, variables, tipos de datos, un primer vistazo a vectores, operadores de comparación, cómo usar la ayuda integrada de R, e instalar/cargar librerías. El [capítulo 1](capitulo01_vectores_tipos.md) retoma vectores y tipos de datos con más profundidad y a mayor ritmo — si ya tienes experiencia programando, puedes avanzar directo a ese capítulo y usar este como referencia.

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

## 6. Operadores de comparación

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

Crea un vector `temperaturas` con las temperaturas (en °C) de 7 días de la semana. Calcula:

a. la temperatura promedio de la semana
b. cuántos días la temperatura fue mayor a 25°C
c. un vector lógico que indique en qué días la temperatura estuvo entre 20°C y 28°C (inclusive)

## Solución al ejercicio

```r
temperaturas <- c(22, 25, 28, 19, 31, 24, 27)

# a) Temperatura promedio
promedio <- mean(temperaturas)
promedio

# b) Días con más de 25°C
sum(temperaturas > 25)          # sum() sobre un lógico cuenta los TRUE

# c) Días entre 20°C y 28°C (inclusive)
temperaturas >= 20 & temperaturas <= 28
```

El truco en el inciso (b) — `sum()` sobre un vector lógico — es un patrón que vas a repetir muchísimo en R: `TRUE` se trata como `1` y `FALSE` como `0`, así que sumar un vector lógico cuenta cuántos `TRUE` hay.

---

[Índice](../../README.md) · [Capítulo 1 →](capitulo01_vectores_tipos.md)
