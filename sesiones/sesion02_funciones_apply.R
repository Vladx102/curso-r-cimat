# =============================================================================
# Sesión 2 — Día 1 · tarde — Funciones propias y familia apply
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Manejar NA, escribir funciones propias y usar la familia apply como
#   puente entre loops y vectorización.

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
