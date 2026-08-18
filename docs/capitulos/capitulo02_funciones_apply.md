# Capítulo 2 — Funciones propias y familia apply

**Sesión 2 · Día 1, tarde · 2 horas**
Script de práctica: [`sesiones/sesion02_funciones_apply.R`](../../sesiones/sesion02_funciones_apply.R)

[← Capítulo 1](capitulo01_vectores_tipos.md) · [Índice](../../README.md) · [Capítulo 2b →](capitulo02b_matrices.md)

## Objetivo

Manejar `NA` correctamente, escribir funciones propias con argumentos flexibles, y usar la familia `apply` como puente entre loops y vectorización.

## 1. NA: el valor faltante

`NA` representa un dato faltante y **se propaga** por default: cualquier operación que lo incluya da `NA`, a menos que le digas explícitamente que lo ignore.

```r
w <- c(1, 2, NA, 4)
sum(w)                   # NA
sum(w, na.rm = TRUE)     # 7
is.na(w)
mean(w, na.rm = TRUE)
```

Este comportamiento es intencional: R prefiere avisarte de un dato faltante en vez de ocultarlo silenciosamente. El costo es que tienes que acordarte de `na.rm = TRUE` en casi todas las funciones de resumen.

## 2. Estructuras de control

El `for` y el `if`/`else` funcionan como en cualquier lenguaje, con una nota de sintaxis: `1:3` es azúcar sintáctica para `seq(1, 3)`.

```r
for (i in 1:3) print(i)

n <- 7
if (n %% 2 == 0) {
  print("par")
} else {
  print("impar")
}
```

Lo distintivo de R es `ifelse()`, la versión **vectorizada** de un if/else escalar — evalúas la condición sobre un vector completo de una sola vez:

```r
ifelse(v %% 4 == 0, "múltiplo de 4", "no")
```

## 3. Funciones propias

Definir una función es similar a otros lenguajes, pero R tiene dos convenciones muy usadas: argumentos con valor por default, y `...` (dots) para reenviar argumentos extra a funciones internas sin tener que declararlos uno por uno.

```r
estandarizar <- function(x, na.rm = TRUE) {
  (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
}
estandarizar(v)

resumen <- function(x, ...) {
  c(media = mean(x, ...), sd = sd(x, ...))
}
resumen(w, na.rm = TRUE)
```

El patrón `...` es muy común en el tidyverse: te permite escribir funciones "delgadas" que delegan el trabajo pesado a funciones ya existentes, sin perder flexibilidad.

## 4. Listas: la estructura heterogénea

A diferencia de un vector (homogéneo), una lista puede contener elementos de distintos tipos — el equivalente de un `dict` o un `struct`.

```r
persona <- list(nombre = "Ana", edad = 27, notas = c(9, 8, 10))
persona$nombre
persona[["notas"]]
str(persona)     # tu mejor amigo para inspeccionar cualquier objeto
```

`str()` (structure) es la primera función que deberías correr cuando no sabes qué forma tiene un objeto — funciona con listas, data frames, modelos ajustados, prácticamente cualquier cosa.

## 5. Familia apply: el puente entre loops y vectorización

Cuando necesitas aplicar una función a cada elemento de una lista o a cada columna de un data frame, la familia `apply` es la alternativa idiomática a escribir un `for`.

```r
lista_vectores <- list(a = 1:5, b = 6:10, c = 11:15)

sapply(lista_vectores, mean)      # simplifica a vector/matriz cuando puede
lapply(lista_vectores, mean)      # siempre regresa lista
vapply(lista_vectores, mean, numeric(1))  # como sapply, con tipo esperado explícito
```

`sapply()` es tu punto de entrada natural. Si el resultado no se puede simplificar de forma consistente, R regresa una lista de todos modos — en ese caso, o cuando quieres una garantía de tipo, usa `lapply()` o `vapply()`.

Aplicado a un data frame, obtienes una función por columna:

```r
sapply(mtcars[, c("mpg", "hp", "wt")], mean)
```

## Ejercicios

1. Crea un vector `edades` con al menos 8 valores numéricos, incluyendo un `NA`. Calcula la media y la desviación estándar ignorando el `NA`.
2. Escribe una función `rango()` que reciba un vector y regrese `max(x) - min(x)`, ignorando NAs por default pero permitiendo cambiarlo con un argumento `na.rm`.
3. Usando `mtcars`, calcula con `sapply()` la media y la desviación estándar de cada columna numérica.

---

[← Capítulo 1](capitulo01_vectores_tipos.md) · [Índice](../../README.md) · [Capítulo 2b →](capitulo02b_matrices.md)
