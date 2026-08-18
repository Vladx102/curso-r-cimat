# =============================================================================
# Sesión 7 — Día 4 · mañana — Regresión lineal
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Interpretar la notación de fórmula, ajustar modelos con lm(), leer
#   summary() y trabajar con factores y niveles de referencia.

library(tidyverse)
library(broom)

datos <- as_tibble(mpg)

# -----------------------------------------------------------------------------
# 1. La notación de fórmula: y ~ x
# -----------------------------------------------------------------------------
# y ~ x1 + x2          modelo aditivo
# y ~ x1 * x2          x1 + x2 + interacción x1:x2
# y ~ x1 + x2 - 1       sin intercepto
# y ~ .                todas las demás columnas como predictoras

modelo_simple <- lm(hwy ~ displ, data = datos)
modelo_simple

# -----------------------------------------------------------------------------
# 2. summary(): la salida estándar de un modelo
# -----------------------------------------------------------------------------

summary(modelo_simple)

# Piezas clave:
#  - Estimate: coeficientes estimados (pendiente e intercepto)
#  - Std. Error, t value, Pr(>|t|): prueba de significancia de cada coeficiente
#  - Multiple R-squared / Adjusted R-squared: bondad de ajuste
#  - F-statistic: prueba global del modelo

# broom::tidy() da la misma info en formato tibble (mejor para programar)
tidy(modelo_simple, conf.int = TRUE)
glance(modelo_simple)     # métricas de resumen (R2, AIC, BIC, etc.) en una fila

# -----------------------------------------------------------------------------
# 3. Modelo múltiple y factores
# -----------------------------------------------------------------------------

modelo_multi <- lm(hwy ~ displ + cyl + class, data = datos)
summary(modelo_multi)

# class es un factor (character -> factor automático dentro de lm).
# R elige un nivel de referencia (por default, el primero alfabéticamente)
# y reporta los demás como diferencias respecto a ese nivel.
levels(factor(datos$class))
contrasts(factor(datos$class))     # matriz de contrastes tipo "treatment"

# Cambiar el nivel de referencia:
datos_relevel <- datos %>% mutate(class = relevel(factor(class), ref = "midsize"))
modelo_relevel <- lm(hwy ~ class, data = datos_relevel)
tidy(modelo_relevel)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Ajusta un modelo lm(hwy ~ cty, data = datos). Interpreta la pendiente:
#    ¿cuánto cambia hwy por cada unidad de cty?

# 2. Agrega `year` como predictor adicional (como factor) al modelo_multi.
#    ¿Es significativo? Usa tidy() para revisar su p-value.
