# Capítulo 5 — Proyectos reproducibles

**Sesión 5 · Día 3, mañana · 2 horas**
Script de práctica: [`sesiones/sesion05_proyectos_reproducibles.R`](../../sesiones/sesion05_proyectos_reproducibles.R)

[← Capítulo 4](capitulo04_agregacion_tidyr_ggplot2.md) · [Índice](../../README.md) · [Capítulo 6 →](capitulo06_computo_simulacion.md)

## Objetivo

Estructurar proyectos reproducibles con `.Rproj` y Quarto/R Markdown, y aplicar buenas prácticas al escribir funciones propias. Esta sesión es más de hábitos de trabajo que de sintaxis nueva — pero es la que más tiempo te ahorra a mediano plazo.

## 1. Proyectos y organización

Una estructura recomendada para un proyecto de análisis:

```
mi_proyecto/
  mi_proyecto.Rproj     <- abre R con el working directory correcto
  data/                 <- datos crudos (no se modifican a mano)
  R/                    <- funciones propias (source()-eables)
  analisis.qmd          <- el reporte/análisis reproducible
  outputs/               <- figuras y tablas generadas
```

**Regla de oro: nunca uses `setwd("C:/Users/...")` con rutas absolutas.** Un archivo `.Rproj` (o el paquete `here`) hace que tu script corra igual en tu laptop, en la de un compañero, o en un servidor — sin tener que editar rutas a mano cada vez.

Este mismo repositorio sigue esa convención: [`curso-r-cimat.Rproj`](../../curso-r-cimat.Rproj) en la raíz, scripts en [`sesiones/`](../../sesiones), documentación en [`docs/`](.).

## 2. Quarto / R Markdown

Un documento `.qmd` combina texto en Markdown con código ejecutable (chunks). Es la herramienta estándar para producir reportes reproducibles en R:

```markdown
---
title: "Mi análisis"
format: html
---

## Introducción

```{r}
#| label: carga-datos
#| echo: false
library(tidyverse)
datos <- mpg
```

El promedio de hwy es `r round(mean(datos$hwy), 1)`.
```

La ventaja sobre copiar resultados a mano en un Word: si cambian los datos, el reporte se regenera solo con *render* (`Ctrl/Cmd+Shift+K` en RStudio). El mini-proyecto integrador del final del curso (capítulo 10) se entrega precisamente en este formato.

## 3. Funciones propias: buenas prácticas

Documentar qué recibe y qué regresa una función es barato de escribir ahora y muy valioso cuando la reutilices en tres meses (o cuando alguien más la lea). El estilo `roxygen2` (los comentarios `#'`) es el estándar en el ecosistema de R, incluso si no vas a convertir el código en un paquete formal.

```r
#' Calcula el error estándar de la media
#' @param x vector numérico
#' @param na.rm si se deben ignorar NAs
error_estandar <- function(x, na.rm = TRUE) {
  n <- if (na.rm) sum(!is.na(x)) else length(x)
  sd(x, na.rm = na.rm) / sqrt(n)
}

error_estandar(c(1, 2, 3, NA, 5))
```

La recomendación práctica: guarda tus funciones propias en `R/funciones.R` (no mezcladas con el análisis) y cárgalas donde las necesites:

```r
source("R/funciones.R")
```

Esta función, `error_estandar()`, la vamos a reutilizar tal cual en el capítulo 6.

## Ejercicios

1. Escribe una función `coef_variacion(x, na.rm = TRUE)` que regrese `sd(x) / mean(x)`, documentada con el mismo estilo que `error_estandar()`.
2. Crea un archivo `R/funciones.R` con al menos dos funciones propias (puedes reutilizar `estandarizar()` y `resumen()` del capítulo 2) y cárgalas en un script nuevo con `source("R/funciones.R")`.
3. Crea un proyecto de RStudio (`.Rproj`) con carpetas `data/`, `R/` y `outputs/`, y verifica que `getwd()` apunta a la raíz del proyecto sin usar `setwd()`.

---

[← Capítulo 4](capitulo04_agregacion_tidyr_ggplot2.md) · [Índice](../../README.md) · [Capítulo 6 →](capitulo06_computo_simulacion.md)
