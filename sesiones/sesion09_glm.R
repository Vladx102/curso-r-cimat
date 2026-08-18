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

# =============================================================================
# EJEMPLO ELABORADO: comparar modelos anidados y predecir escenarios
# =============================================================================

modelo_reducido_logit <- glm(traccion_4wd ~ displ, data = datos, family = binomial)
modelo_completo_logit <- glm(traccion_4wd ~ displ + cyl + hwy, data = datos, family = binomial)

# Prueba de razón de verosimilitudes: el análogo de anova() para modelos
# lineales (sesión 8), pero con test = "Chisq" porque los GLM no se
# comparan con una F como en lm()
anova(modelo_reducido_logit, modelo_completo_logit, test = "Chisq")

# Probabilidad estimada de 4WD para tres autos hipotéticos
autos_hipoteticos <- tibble(
  displ = c(1.8, 3.0, 5.7),
  cyl = c(4, 6, 8),
  hwy = c(35, 26, 18)
)
autos_hipoteticos %>%
  mutate(prob_4wd = predict(modelo_completo_logit, newdata = ., type = "response"))

# ¿A partir de qué displ la probabilidad estimada de 4WD supera 50%,
# manteniendo cyl y hwy en su promedio?
grid_displ <- tibble(
  displ = seq(min(datos$displ), max(datos$displ), by = 0.1),
  cyl = mean(datos$cyl),
  hwy = mean(datos$hwy)
)
grid_displ %>%
  mutate(prob_4wd = predict(modelo_completo_logit, newdata = ., type = "response")) %>%
  filter(prob_4wd >= 0.5) %>%
  slice(1)

# =============================================================================
# EJERCICIOS ADICIONALES
# =============================================================================

# 3. Usando modelo_poisson (warpbreaks), predice el número esperado de
#    roturas para wool = "A" y tension = "L" con
#    predict(..., type = "response").

# 4. (Reto) Compara con anova(..., test = "Chisq") el modelo_poisson contra
#    una versión sin wool (breaks ~ tension). ¿Aporta wool información
#    significativa?
