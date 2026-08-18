# Capítulo 2 — Funciones propias y familia apply

**Sesión 2 · Día 1, tarde · 2 horas**
Script de práctica: [`sesiones/sesion02_funciones_apply.R`](../../sesiones/sesion02_funciones_apply.R)

[← Capítulo 1](capitulo01_vectores_tipos.md) · [Índice](../../README.md) · [Capítulo 2b →](capitulo02b_matrices.md)

## Objetivo

Manejar `NA` correctamente, dominar las estructuras de control de R (`for`, `if`/`else`, `while`, `repeat`, `break`/`next`, `switch`), escribir funciones propias (incluyendo `return()`, funciones anónimas, ámbito de variables y recursión), y usar la familia `apply` como puente entre loops y vectorización.

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

R también tiene `while` (se repite mientras la condición sea `TRUE`) y `repeat` (un loop infinito que **siempre** necesita un `break` para terminar):

```r
contador <- 1
while (contador <= 3) {
  print(contador)
  contador <- contador + 1
}

contador <- 1
repeat {
  print(contador)
  contador <- contador + 1
  if (contador > 3) break
}
```

`break` y `next` funcionan igual que en la mayoría de los lenguajes: `break` sale del loop por completo, `next` salta directo a la siguiente iteración.

```r
for (i in 1:10) {
  if (i %% 2 == 0) next        # salta los pares
  if (i > 7) break             # se detiene antes de llegar a 10
  print(i)
}
```

Para evitar una cadena larga de `if`/`else if` cuando comparas una sola variable contra varios valores posibles, `switch()` es más legible:

```r
dia <- "mar"
tipo_dia <- switch(
  dia,
  sab = ,                      # sin cuerpo: "cae" al siguiente caso (como en C)
  dom = "fin de semana",
  "día entre semana"           # valor por default si no coincide ningún caso
)
tipo_dia
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

Por default, una función de R regresa el valor de la **última expresión evaluada** (retorno implícito) — así están escritas `estandarizar()` y `resumen()` de arriba. `return()` es igual de válido y a veces más claro, sobre todo para salir antes de tiempo:

```r
clasificar <- function(x) {
  if (is.na(x)) {
    return("sin dato")
  }
  if (x >= 60) {
    return("aprobado")
  }
  "reprobado"      # última expresión: se regresa sin necesidad de return()
}
clasificar(75)
clasificar(40)
clasificar(NA)
```

Cuando una función se usa una sola vez — típicamente dentro de `sapply()`/`lapply()` — no siempre vale la pena nombrarla. R permite dos sintaxis equivalentes para funciones anónimas (lambda):

```r
sapply(1:5, function(x) x^2)     # sintaxis clásica
sapply(1:5, \(x) x^2)             # azúcar sintáctica desde R 4.1
```

Una función ve las variables definidas fuera de ella (su entorno), pero lo que se crea **dentro** de la función no existe afuera: cada llamada trabaja con su propia copia local.

```r
z <- 100
sumar_a_z <- function(x) {
  z <- z + x   # este z es una copia local; no modifica el z de afuera
  z
}
sumar_a_z(5)
z              # sigue siendo 100: la función no tiene efectos secundarios
```

Una función también puede llamarse a sí misma (recursión). Como en cualquier lenguaje, necesita un caso base para no recursar infinitamente:

```r
factorial_recursivo <- function(n) {
  if (n <= 1) return(1)          # caso base
  n * factorial_recursivo(n - 1) # llamada recursiva
}
factorial_recursivo(5)   # 5 * 4 * 3 * 2 * 1 = 120
```

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
4. Usando `while`, imprime los primeros 5 números de Fibonacci (1, 1, 2, 3, 5).
5. Con un `for` y `next`/`break`, imprime los múltiplos de 3 entre 1 y 30, pero detente en cuanto encuentres uno mayor a 20.
6. Escribe una función `es_par(x)` que regrese `TRUE`/`FALSE` usando `return()` dentro de un `if`/`else` (en vez de dejar el retorno implícito).
7. Reescribe el ejercicio 6 como función anónima con `\(x) ...` y úsala directamente dentro de un `sapply()` sobre el vector `1:10`.
8. Escribe una función recursiva `fibonacci(n)` que regrese el n-ésimo número de Fibonacci (`fibonacci(1) = 1`, `fibonacci(2) = 1`, `fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)`). Compara el resultado con tu solución iterativa del ejercicio 4.

---

[← Capítulo 1](capitulo01_vectores_tipos.md) · [Índice](../../README.md) · [Capítulo 2b →](capitulo02b_matrices.md)
