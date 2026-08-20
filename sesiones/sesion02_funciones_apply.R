# =============================================================================
# Sesión 2 — Día 1 · tarde — Funciones propias y familia apply
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Manejar NA, dominar las estructuras de control de R (for, if/else,
#   while, repeat, break/next, switch), escribir funciones propias
#   (incluyendo return(), funciones anónimas, ámbito de variables y
#   recursión), y usar la familia apply como puente entre loops y
#   vectorización.

v <- c(2, 4, 6, 8, 10)   # retomamos el vector de la sesión 1

# -----------------------------------------------------------------------------
# 1. NA: el valor faltante
# -----------------------------------------------------------------------------

w <- c(1, 2, NA, 4)
sum(w)                   # NA se propaga
sum(w, na.rm = TRUE)     # hay que ser explícito
is.na(w)
mean(w, na.rm = TRUE)

# -----------------------------------------------------------------------------
# 2. Estructuras de control (donde difieren de lo usual)
# -----------------------------------------------------------------------------

for (i in 1:3) print(i)     # 1:3 es azúcar sintáctica para seq(1, 3)

n <- 7
if (n %% 2 == 0) {
  print("par")
} else {
  print("impar")
}

# ifelse() vectorizado (muy usado, distinto de if/else escalar)
ifelse(v %% 4 == 0, "múltiplo de 4", "no")

# while: se repite mientras la condición sea TRUE
contador <- 1
while (contador <= 3) {
  print(contador)
  contador <- contador + 1
}

# repeat: loop infinito: SIEMPRE necesita un break para terminar
contador <- 1
repeat {
  print(contador)
  contador <- contador + 1
  if (contador > 3) break
}

rep(8,7)

# break sale del loop por completo; next salta a la siguiente iteración
# (mismo comportamiento que en la mayoría de los lenguajes)
for (i in 1:10) {
  if (i %% 2 == 0) next        # salta los pares
  if (i > 7) break             # se detiene antes de llegar a 10
  print(i)
}

# switch(): alternativa a una cadena larga de if/else if para un solo valor
dia <- "mar"
tipo_dia <- switch(
  dia,
  sab = ,                      # sin cuerpo: "cae" al siguiente caso (como en C)
  dom = "fin de semana",
  "día entre semana"           # valor por default si no coincide ningún caso
)
tipo_dia

mes_abrev <- "dic"

switch(
  mes_abrev,
  dic = ,
  ene = ,
  feb = "invierno",
  mar = ,
  abr = ,
  may = "primavera",
  "otra estación"
)

# -----------------------------------------------------------------------------
# 3. Funciones
# -----------------------------------------------------------------------------

estandarizar <- function(x, na.rm = TRUE) {
  (x - mean(x, na.rm = na.rm)) / sd(x, na.rm = na.rm)
}
estandarizar(v)

# Argumentos con default, ... (dots) para pasar argumentos extra
resumen <- function(x, ...) {
  c(media = mean(x, ...), sd = sd(x, ...))
}
resumen(w, na.rm = TRUE)

# -- return() explícito --------------------------------------------------
# Por default se regresa la última expresión evaluada (retorno implícito).
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

# -- Funciones anónimas (lambda) ------------------------------------------
# Cuando una función se usa una sola vez (típicamente dentro de sapply()/
# lapply()), no siempre vale la pena nombrarla. R permite dos sintaxis:
sapply(1:5, function(x) x^2)     # sintaxis clásica
sapply(1:5, \(x) x^2)             # azúcar sintáctica desde R 4.1 (equivalente)

# -- Ámbito de variables (scope) -------------------------------------------
# Una función ve las variables definidas fuera de ella (su entorno), pero
# lo que se crea DENTRO de la función no existe afuera.
z <- 100
sumar_a_z <- function(x) {
  z <- z + x   # este `z` es una copia local; no modifica el z de afuera
  z
}
sumar_a_z(5)
z              # sigue siendo 100: la función no tiene efectos secundarios

# -- Recursión ---------------------------------------------------------
# Una función puede llamarse a sí misma. Como en cualquier lenguaje, necesita
# un caso base para no recursar infinitamente.
factorial_recursivo <- function(n) {
  if (n <= 1) return(1)         # caso base
  n * factorial_recursivo(n - 1) # llamada recursiva
}
factorial_recursivo(5)   # 5 * 4 * 3 * 2 * 1 = 120

# -----------------------------------------------------------------------------
# 4. Listas: la estructura heterogénea (equivalente a dict/struct)
# -----------------------------------------------------------------------------

persona <- list(nombre = "Ana", edad = 27, notas = c(9, 8, 10))
persona$nombre
persona[["notas"]]
str(persona)     # str() es tu mejor amigo para inspeccionar cualquier objeto

# -----------------------------------------------------------------------------
# 5. Familia apply: el puente entre loops y vectorización
# -----------------------------------------------------------------------------

lista_vectores <- list(a = 1:5, b = 6:10, c = 11:15)

sapply(lista_vectores, mean)      # simplifica a vector/matriz cuando puede
lapply(lista_vectores, mean)      # siempre regresa lista
vapply(lista_vectores, mean, numeric(1))  # como sapply, pero con tipo esperado explícito (más seguro)

# También funciona sobre un data frame, columna por columna:
sapply(list(mpg = mtcars$mpg, hp = mtcars$hp, wt = mtcars$wt), mean)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Crea un vector `edades` con al menos 8 valores numéricos, incluyendo un
#    NA. Calcula la media y la desviación estándar ignorando el NA.

# 2. Escribe una función `rango()` que reciba un vector y regrese
#    max(x) - min(x), ignorando NAs por default pero permitiendo cambiarlo
#    con un argumento na.rm.

# 3. Usando el dataset built-in `mtcars`, calcula con sapply() la media y la
#    desviación estándar de cada columna numérica. Pista: usa una función
#    anónima o \(x) resumen(x).

# 4. Usando while, imprime los primeros 5 números de Fibonacci (1, 1, 2, 3, 5).

# 5. Con un for y next/break, imprime los múltiplos de 3 entre 1 y 30,
#    pero detente en cuanto encuentres uno mayor a 20.

# 6. Escribe una función es_par(x) que regrese TRUE/FALSE usando return()
#    dentro de un if/else (en vez de dejar el retorno implícito).

# 7. Reescribe el ejercicio 6 como función anónima con \(x) ... y úsala
#    directamente dentro de un sapply() sobre el vector 1:10.

# 8. Escribe una función recursiva fibonacci(n) que regrese el n-ésimo
#    número de Fibonacci (fibonacci(1) = 1, fibonacci(2) = 1,
#    fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)). Compara el resultado
#    con tu solución iterativa del ejercicio 4.

# =============================================================================
# EJEMPLO: procesar varios grupos con una función propia
# =============================================================================
# Combina NA, control de flujo, función propia y la familia apply -- el tipo
# de mini-pipeline que vas a construir seguido.

grupo_A <- c(78, 92, NA, 55, 88)
grupo_B <- c(60, NA, NA, 71, 45)
grupo_C <- c(95, 89, 91, 84, 99)
grupos <- list(A = grupo_A, B = grupo_B, C = grupo_C)

# Resume un grupo: NAs, promedio y si aprueba (promedio >= 60).
resumen_grupo <- function(x) {
  n_na <- sum(is.na(x))
  prom <- mean(x, na.rm = TRUE)

  if (n_na > length(x) / 2) {
    return(c(n_na = n_na, promedio = NA, aprueba = NA))
  }

  aprueba <- if (prom >= 60) 1 else 0
  c(n_na = n_na, promedio = round(prom, 1), aprueba = aprueba)
}

# Aplicar la función a cada grupo con sapply() -> una matriz, un grupo por columna
resultado <- sapply(grupos, resumen_grupo)
resultado

# ¿Cuántos grupos aprueban? (con un for a propósito, para practicar control de flujo)
total_aprueban <- 0
for (nombre_grupo in colnames(resultado)) {
  if (!is.na(resultado["aprueba", nombre_grupo]) &&
      resultado["aprueba", nombre_grupo] == 1) {
    total_aprueban <- total_aprueban + 1
  }
}
total_aprueban

# 9. Escribe tu propia función `resumen_ventas(x)` que reciba un vector de
#    montos de venta (con algunos NA) y regrese un vector con nombres:
#    n_na, promedio, y una bandera meta_cumplida (1 si el promedio >= 500,
#    0 si no, NA si más de la mitad del vector son NA). Pruébala con
#    sapply() sobre una lista `ventas_por_dia` con al menos 3 vectores.

# 10. (Reto) Modifica tu función `resumen_ventas()` para que, en vez de un
#     vector con nombres, regrese una LISTA con un elemento extra
#     "posiciones_na" que sea el vector de posiciones (which()) donde hay
#     NA en ese vector.
