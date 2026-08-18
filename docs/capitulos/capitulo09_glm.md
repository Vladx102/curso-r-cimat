# Capítulo 9 — Modelos lineales generalizados

**Sesión 9 · Día 5, mañana · 2 horas**
Script de práctica: [`sesiones/sesion09_glm.R`](../../sesiones/sesion09_glm.R)

[← Capítulo 8](capitulo08_diagnostico_anova.md) · [Índice](../../README.md) · [Capítulo 10 →](capitulo10_validacion_cierre.md)

## Objetivo

Extender `lm()` a modelos lineales generalizados (logística, Poisson) y seleccionar modelos con AIC/BIC y `step()`.

## 1. glm(): la misma fórmula, distinta familia

`lm()` es, matemáticamente, un caso particular de `glm()` con `family = gaussian()`. La sintaxis de fórmula es casi idéntica entre ambas funciones — lo único que cambia es el argumento `family`, que le dice al modelo qué tipo de variable de respuesta estás modelando.

```r
library(tidyverse)
library(broom)

datos <- as_tibble(mpg) %>%
  mutate(traccion_4wd = if_else(drv == "4", 1, 0))
```

## 2. Regresión logística (respuesta binaria)

```r
modelo_logit <- glm(traccion_4wd ~ displ + cyl + hwy, data = datos, family = binomial)
summary(modelo_logit)
```

Los coeficientes de una regresión logística viven en la escala de **log-odds**, que no es directamente interpretable. Exponenciarlos los convierte en **odds ratios**, mucho más intuitivos: un odds ratio de 2 significa que las probabilidades (odds) de la respuesta se duplican por cada unidad de aumento en el predictor.

```r
tidy(modelo_logit, exponentiate = TRUE, conf.int = TRUE)
```

Para predicciones en escala de probabilidad (entre 0 y 1) en vez de log-odds, usa `type = "response"`:

```r
datos_pred <- datos %>%
  mutate(prob_4wd = predict(modelo_logit, type = "response"))

ggplot(datos_pred, aes(displ, prob_4wd)) +
  geom_point(aes(y = traccion_4wd), alpha = 0.3) +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE) +
  labs(title = "Probabilidad estimada de tracción 4WD", y = "P(4WD)") +
  theme_minimal()
```

## 3. Regresión de Poisson (conteos)

Cuando la variable de respuesta es un conteo (número de eventos), `family = poisson` es el punto de partida estándar. El ejemplo clásico en R es `warpbreaks`: número de roturas de hilo según tipo de lana y nivel de tensión.

```r
data(warpbreaks)
modelo_poisson <- glm(breaks ~ wool + tension, data = warpbreaks, family = poisson)
summary(modelo_poisson)
tidy(modelo_poisson, exponentiate = TRUE, conf.int = TRUE)   # ratios de tasa (rate ratios)
```

Vale la pena revisar sobredispersión antes de confiar en un modelo de Poisson: si la varianza es mucho mayor que la media, el supuesto del modelo (media = varianza) no se cumple, y conviene considerar `quasipoisson` o binomial negativa.

```r
mean(warpbreaks$breaks); var(warpbreaks$breaks)
```

## 4. Selección de modelos: AIC/BIC y step()

AIC y BIC son criterios que penalizan la complejidad del modelo (número de predictores) contra qué tan bien ajusta — menor AIC/BIC generalmente indica un mejor balance entre ajuste y parsimonia.

```r
modelo_completo <- glm(traccion_4wd ~ displ + cyl + hwy + cty + year, data = datos, family = binomial)

AIC(modelo_completo)
BIC(modelo_completo)

modelo_reducido <- step(modelo_completo, direction = "backward", trace = 0)
summary(modelo_reducido)
```

`step()` automatiza la búsqueda de un mejor subconjunto de predictores, pero **no reemplaza el criterio del analista**: siempre hay que revisar que el modelo final tenga sentido sustantivo dentro del problema, no solo un mejor número estadístico.

## Ejercicios

1. Ajusta un modelo logístico para predecir si un auto es automático o manual usando `mtcars` (variable `am`), con `hp` y `wt` como predictores.
2. Usando `warpbreaks`, compara por AIC un modelo con interacción `wool*tension` contra el modelo aditivo `wool + tension`. ¿Cuál prefieres?

---

[← Capítulo 8](capitulo08_diagnostico_anova.md) · [Índice](../../README.md) · [Capítulo 10 →](capitulo10_validacion_cierre.md)
