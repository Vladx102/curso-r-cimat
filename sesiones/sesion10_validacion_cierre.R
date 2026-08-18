# =============================================================================
# Sesión 10 — Día 5 · tarde — Validación de modelos y cierre del curso
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Validar modelos con train/test y validación cruzada, usar broom para
#   reportar resultados, y cerrar con el mini-proyecto integrador.

library(tidyverse)
library(broom)

datos <- as_tibble(mpg) %>%
  mutate(traccion_4wd = if_else(drv == "4", 1, 0))

# -----------------------------------------------------------------------------
# 1. Validación: train/test y validación cruzada básica
# -----------------------------------------------------------------------------

set.seed(2026)
n <- nrow(datos)
idx_train <- sample(seq_len(n), size = floor(0.8 * n))

train <- datos[idx_train, ]
test <- datos[-idx_train, ]

modelo_train <- glm(traccion_4wd ~ displ + cyl + hwy, data = train, family = binomial)
pred_test <- predict(modelo_train, newdata = test, type = "response")
clase_test <- if_else(pred_test > 0.5, 1, 0)

exactitud <- mean(clase_test == test$traccion_4wd)
exactitud

# Matriz de confusión sobre el conjunto de prueba
table(observado = test$traccion_4wd, predicho = clase_test)

# Validación cruzada k-fold (manual, para entender el mecanismo)
set.seed(2026)
k <- 5
folds <- sample(rep(1:k, length.out = n))

exactitudes <- map_dbl(1:k, function(i) {
  train_k <- datos[folds != i, ]
  test_k <- datos[folds == i, ]
  m <- glm(traccion_4wd ~ displ + cyl + hwy, data = train_k, family = binomial)
  p <- predict(m, newdata = test_k, type = "response")
  mean(if_else(p > 0.5, 1, 0) == test_k$traccion_4wd)
})
exactitudes
mean(exactitudes)

# -----------------------------------------------------------------------------
# 2. broom para reportar resultados de forma ordenada
# -----------------------------------------------------------------------------

modelo_final <- glm(traccion_4wd ~ displ + cyl + hwy, data = datos, family = binomial)

tidy(modelo_final, conf.int = TRUE, exponentiate = TRUE) %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(x = fct_reorder(term, estimate), y = estimate)) +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(title = "Odds ratios con IC 95%", x = NULL, y = "Odds ratio") +
  theme_minimal()

# =============================================================================
# EJEMPLO: comparar dos modelos con validación cruzada
# =============================================================================
# La validación cruzada no es solo para reportar un número -- sirve para
# DECIDIR entre modelos candidatos de forma más confiable que comparar su
# ajuste sobre los mismos datos con los que se entrenaron.

comparar_modelo_cv <- function(formula, datos, folds, k) {
  exactitudes <- map_dbl(1:k, function(i) {
    train_k <- datos[folds != i, ]
    test_k <- datos[folds == i, ]
    m <- glm(formula, data = train_k, family = binomial)
    p <- predict(m, newdata = test_k, type = "response")
    mean(if_else(p > 0.5, 1, 0) == test_k$traccion_4wd)
  })
  mean(exactitudes)
}

# Reutilizamos los mismos folds del ejemplo anterior para que la comparación
# sea justa (los dos modelos se evalúan sobre exactamente los mismos splits)
cv_simple <- comparar_modelo_cv(traccion_4wd ~ displ, datos, folds, k)
cv_completo <- comparar_modelo_cv(traccion_4wd ~ displ + cyl + hwy + cty, datos, folds, k)

tibble(
  modelo = c("simple (displ)", "completo (displ+cyl+hwy+cty)"),
  exactitud_cv = c(cv_simple, cv_completo)
)

# =============================================================================
# MINI-PROYECTO INTEGRADOR (entrega del curso)
# =============================================================================
#
# Elige un dataset (puede ser uno de los incluidos en R: diamonds, txhousing,
# starwars, o uno propio de tu área) y entrega un documento Quarto (.qmd)
# renderizado a HTML que incluya:
#
#   1. Descripción breve del dataset y la pregunta que quieres responder.
#   2. Limpieza/transformación de datos con dplyr/tidyr.
#   3. Al menos 2 visualizaciones con ggplot2 que exploren la pregunta.
#   4. Un modelo (lm o glm) que aborde la pregunta, con:
#        - tabla de coeficientes (tidy())
#        - una gráfica de diagnóstico o de efectos
#        - 3-5 líneas interpretando los resultados en el contexto del problema
#   5. Una sección de "limitaciones" (qué no captura el modelo).
#
# Extensión sugerida: 3-5 páginas renderizadas. Se evalúa reproducibilidad
# (el .qmd debe correr de principio a fin sin errores) y claridad de la
# interpretación, no la complejidad del modelo.

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Calcula la matriz de confusión y la exactitud del modelo del ejercicio 1
#    de la sesión 9 (am ~ hp + wt en mtcars), usando todos los datos como
#    entrenamiento.

# 2. (Reto) Implementa validación cruzada de 5 folds para ese mismo modelo
#    logístico sobre mtcars y reporta la exactitud promedio.

# 3. Usa comparar_modelo_cv() del ejemplo para evaluar un tercer
#    modelo, traccion_4wd ~ displ + class, y decide cuál de los tres
#    modelos (simple, completo, con class) tiene mejor exactitud promedio.

# 4. (Reto) Modifica comparar_modelo_cv() para que además regrese la
#    desviación estándar de las exactitudes entre folds (no solo el
#    promedio) -- un modelo con exactitud promedio similar pero menor
#    variación entre folds es, en general, preferible.
