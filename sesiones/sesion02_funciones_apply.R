# =============================================================================
# Sesión 2 — Día 1 · tarde — Funciones propias y familia apply
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Manejar NA, dominar las estructuras de control de R (for, if/else,
#   while, repeat, break/next, switch), escribir funciones propias y usar
#   la familia apply como puente entre loops y vectorización.

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

# -----------------------------------------------------------------------------
# 3. Funciones propias
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

# Con data frames, por columna:
sapply(mtcars[, c("mpg", "hp", "wt")], mean)

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
