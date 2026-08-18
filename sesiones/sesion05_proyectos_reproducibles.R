# =============================================================================
# Sesión 5 — Día 3 · mañana — Proyectos reproducibles
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Estructurar proyectos reproducibles con .Rproj y Quarto/R Markdown, y
#   aplicar buenas prácticas al escribir funciones propias.

library(tidyverse)

# -----------------------------------------------------------------------------
# 1. Proyectos y organización (no se ejecuta, es referencia)
# -----------------------------------------------------------------------------
# Estructura recomendada de un proyecto de análisis:
#
#   mi_proyecto/
#     mi_proyecto.Rproj     <- abre R con el working directory correcto
#     data/                 <- datos crudos (no se modifican a mano)
#     R/                    <- funciones propias (source()-eables)
#     analisis.qmd          <- el reporte/análisis reproducible
#     outputs/               <- figuras y tablas generadas
#
# Regla de oro: nunca usar setwd("C:/Users/...") con rutas absolutas.
# Usa un .Rproj (o here::here()) para que el script corra en cualquier máquina.

# -----------------------------------------------------------------------------
# 2. Quarto / R Markdown (referencia — se explica en vivo con un .qmd)
# -----------------------------------------------------------------------------
# Un documento .qmd combina texto (Markdown) + código ejecutable (chunks):
#
#   ---
#   title: "Mi análisis"
#   format: html
#   ---
#
#   ## Introducción
#
#   ```{r}
#   #| label: carga-datos
#   #| echo: false
#   library(tidyverse)
#   datos <- mpg
#   ```
#
#   El promedio de hwy es `r round(mean(datos$hwy), 1)`.
#
# Ventaja sobre copiar resultados a mano: si cambian los datos, el
# reporte se regenera solo con render (Ctrl/Cmd+Shift+K en RStudio).

# -----------------------------------------------------------------------------
# 3. Funciones propias: buenas prácticas
# -----------------------------------------------------------------------------

# Documentar con comentarios qué recibe y qué regresa (o usar roxygen2 si
# el código se va a convertir en paquete)

#' Calcula el error estándar de la media
#' @param x vector numérico
#' @param na.rm si se deben ignorar NAs
error_estandar <- function(x, na.rm = TRUE) {
  n <- if (na.rm) sum(!is.na(x)) else length(x)
  sd(x, na.rm = na.rm) / sqrt(n)
}

error_estandar(c(1, 2, 3, NA, 5))

# Guardar funciones propias en R/funciones.R y cargarlas con:
# source("R/funciones.R")

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Escribe una función `coef_variacion(x, na.rm = TRUE)` que regrese
#    sd(x) / mean(x), documentada con comentarios de qué recibe y qué regresa
#    (sigue el estilo de error_estandar() de arriba).

# 2. Crea un archivo R/funciones.R con al menos dos funciones propias
#    (puedes reutilizar estandarizar() y resumen() de la sesión 2) y
#    cárgalas en un script nuevo con source("R/funciones.R").

# 3. Crea un proyecto de RStudio (.Rproj) para el curso, con carpetas
#    data/, R/ y outputs/, y verifica que getwd() apunta a la raíz del
#    proyecto sin usar setwd().

# =============================================================================
# EJEMPLO ELABORADO: un mini "kit" de funciones para reportar notas
# =============================================================================
# Buena práctica más allá de documentar: VALIDAR argumentos y COMPONER
# funciones chicas en vez de escribir una función gigante que hace todo.

#' Valida que un vector de calificaciones esté en el rango [0, 100]
#' @param x vector numérico
#' @return TRUE si es válido; si no, detiene la ejecución con un mensaje claro
validar_calificaciones <- function(x) {
  if (!is.numeric(x)) stop("`x` debe ser numérico")
  if (any(x < 0 | x > 100, na.rm = TRUE)) stop("hay calificaciones fuera de [0, 100]")
  TRUE
}

#' Clasifica calificaciones en letra
#' @param x vector numérico de calificaciones
#' @return vector de character con la letra correspondiente
letra_calificacion <- function(x) {
  validar_calificaciones(x)
  ifelse(x >= 90, "A", ifelse(x >= 70, "B", ifelse(x >= 60, "C", "F")))
}

#' Genera un reporte resumido de un vector de calificaciones
#' @param x vector numérico
#' @param na.rm si se deben ignorar NAs al calcular el promedio
#' @return una lista con promedio, letra_promedio y distribución de letras
reporte_calificaciones <- function(x, na.rm = TRUE) {
  validar_calificaciones(x)
  prom <- mean(x, na.rm = na.rm)
  list(
    promedio = round(prom, 1),
    letra_promedio = letra_calificacion(prom),
    distribucion = table(letra_calificacion(x))
  )
}

reporte_calificaciones(c(95, 82, 67, 58, 71, NA))

# Si le pasamos algo inválido, falla con un mensaje claro en vez de dar un
# resultado silenciosamente incorrecto:
# reporte_calificaciones(c(95, 150, 40))   # Error: hay calificaciones fuera de [0, 100]

# =============================================================================
# EJERCICIOS ADICIONALES
# =============================================================================

# 4. Agrega una función `resumen_texto(reporte)` que reciba la lista que
#    regresa reporte_calificaciones() y construya un string legible como
#    "Promedio: 78.8 (C) -- distribución: A=1, B=1, C=1, F=1" usando paste().

# 5. (Reto) Modifica validar_calificaciones() para que, en vez de stop(),
#    regrese un vector lógico indicando CUÁLES elementos son inválidos
#    (útil para poder filtrarlos en vez de detener el script por completo).
