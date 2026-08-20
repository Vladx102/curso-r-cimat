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

# Piezas clave: Estimate, Std. Error/t value/Pr(>|t|), R-squared, F-statistic.

# broom::tidy() da la misma info en formato tibble (mejor para programar)
tidy(modelo_simple, conf.int = TRUE)
glance(modelo_simple)     # métricas de resumen (R2, AIC, BIC, etc.) en una fila

# -----------------------------------------------------------------------------
# 3. Modelo múltiple y factores
# -----------------------------------------------------------------------------

modelo_multi <- lm(hwy ~ displ + cyl + class, data = datos)
summary(modelo_multi)

# class es un factor; R usa el primer nivel (alfabético) como referencia.
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

# =============================================================================
# EJEMPLO: predicciones e interpretación completa de un modelo
# =============================================================================

modelo_pred <- lm(hwy ~ displ + cyl, data = datos)
tidy(modelo_pred, conf.int = TRUE)

# Predecir hwy para un auto hipotético: displ = 3.5, cyl = 6
auto_nuevo <- tibble(displ = 3.5, cyl = 6)
predict(modelo_pred, newdata = auto_nuevo)

# Intervalo de confianza (para el promedio) vs. de predicción (para un individuo, más ancho):
predict(modelo_pred, newdata = auto_nuevo, interval = "confidence")
predict(modelo_pred, newdata = auto_nuevo, interval = "prediction")

# Comparar varios autos hipotéticos de un jalón
autos_hipoteticos <- tibble(displ = c(2, 3, 4, 5), cyl = c(4, 6, 6, 8))
autos_hipoteticos %>%
  mutate(hwy_estimado = predict(modelo_pred, newdata = .))

# 3. Ajusta tu propio modelo lm(cty ~ displ + cyl, data = datos) y predice
#    cty para un auto con displ = 5 y cyl = 8. Compara el intervalo de
#    confianza y el de predicción de esa estimación -- ¿cuál es más ancho?
#    ¿Por qué crees que sea así?

# 4. (Reto) Ajusta un modelo hwy ~ displ + cyl + class y predice hwy para
#    un auto hipotético de clase "suv" con displ = 4 y cyl = 8. Compara esa
#    predicción contra la de un modelo hwy ~ displ + cyl (sin class) para
#    el mismo auto -- ¿cambia mucho?
