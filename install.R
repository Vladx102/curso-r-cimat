# =============================================================================
# install.R — Instala las dependencias del curso
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Uso:
#   source("install.R")
#
# Todos los ejemplos y ejercicios del curso usan datasets incluidos en R
# (mpg, mtcars, warpbreaks), así que no se necesitan datos externos.

paquetes_requeridos <- c(
  "tidyverse",  # dplyr, tidyr, ggplot2, purrr, readr, tibble, stringr, lubridate...
  "readxl",     # importar archivos Excel (sesión 3)
  "skimr",      # skim(): resúmenes descriptivos rápidos (sesión 6)
  "broom",      # tidy(), glance(), augment() para modelos
  "car"         # vif() para diagnóstico de colinealidad (sesión 8)
)

paquetes_faltantes <- setdiff(paquetes_requeridos, rownames(installed.packages()))

if (length(paquetes_faltantes) > 0) {
  install.packages(paquetes_faltantes)
} else {
  message("Todos los paquetes requeridos ya están instalados.")
}

# Opcional: Quarto (CLI, no es un paquete de R) para renderizar el
# mini-proyecto integrador de la sesión 10.
# Descarga: https://quarto.org/docs/get-started/
