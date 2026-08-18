# =============================================================================
# Sesión 9 — Día 5 · mañana — Modelos lineales generalizados
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Extender lm() a modelos lineales generalizados (logística, Poisson) y
#   seleccionar modelos con AIC/BIC y step().

library(tidyverse)
library(broom)

# -----------------------------------------------------------------------------
# 1. glm(): la misma fórmula, distinta familia
# -----------------------------------------------------------------------------
# lm() es un caso particular de glm() con family = gaussian().
# La sintaxis es casi idéntica; lo que cambia es `family`.

datos <- as_tibble(mpg) %>%
  mutate(traccion_4wd = if_else(drv == "4", 1, 0))

# -----------------------------------------------------------------------------
# 2. Regresión logística (respuesta binaria)
# -----------------------------------------------------------------------------

modelo_logit <- glm(traccion_4wd ~ displ + cyl + hwy, data = datos, family = binomial)
summary(modelo_logit)

# Los coeficientes están en escala log-odds; exponenciar da odds ratios
tidy(modelo_logit, exponentiate = TRUE, conf.int = TRUE)

# Predicciones en escala de probabilidad
datos_pred <- datos %>%
  mutate(prob_4wd = predict(modelo_logit, type = "response"))

ggplot(datos_pred, aes(displ, prob_4wd)) +
  geom_point(aes(y = traccion_4wd), alpha = 0.3) +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE) +
  labs(title = "Probabilidad estimada de tracción 4WD", y = "P(4WD)") +
  theme_minimal()

# -----------------------------------------------------------------------------
# 3. Regresión de Poisson (conteos)
# -----------------------------------------------------------------------------
# Ejemplo clásico: warpbreaks (roturas de hilo por tipo de lana y tensión)

data(warpbreaks)
modelo_poisson <- glm(breaks ~ wool + tension, data = warpbreaks, family = poisson)
summary(modelo_poisson)
tidy(modelo_poisson, exponentiate = TRUE, conf.int = TRUE)   # ratios de tasa (rate ratios)

# Chequeo rápido de sobredispersión (varianza >> media sugiere quasipoisson
# o binomial negativa en vez de poisson)
mean(warpbreaks$breaks); var(warpbreaks$breaks)

# -----------------------------------------------------------------------------
# 4. Selección de modelos: AIC/BIC y step()
# -----------------------------------------------------------------------------

modelo_completo <- glm(traccion_4wd ~ displ + cyl + hwy + cty + year, data = datos, family = binomial)

AIC(modelo_completo)
BIC(modelo_completo)

modelo_reducido <- step(modelo_completo, direction = "backward", trace = 0)
summary(modelo_reducido)

# step() no reemplaza el criterio del analista: siempre revisar que el
# modelo final tenga sentido sustantivo, no solo estadístico.

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Ajusta un modelo logístico para predecir si un auto es automático
#    o manual usando mtcars (variable am), con hp y wt como predictores.

# 2. Usando warpbreaks, compara con AIC un modelo con interacción
#    wool*tension contra el modelo aditivo wool + tension. ¿Cuál prefieres?
