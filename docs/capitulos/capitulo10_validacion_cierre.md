# Capítulo 10 — Validación de modelos y cierre del curso

**Sesión 10 · Día 5, tarde · 2 horas**
Script de práctica: [`sesiones/sesion10_validacion_cierre.R`](../../sesiones/sesion10_validacion_cierre.R)

[← Capítulo 9](capitulo09_glm.md) · [Índice](../../README.md)

## Objetivo

Validar modelos con conjuntos de entrenamiento y prueba, implementar validación cruzada básica, usar broom para reportar resultados de forma ordenada, y cerrar el curso con el mini-proyecto integrador.

```r
library(tidyverse)
library(broom)

datos <- as_tibble(mpg) %>%
  mutate(traccion_4wd = if_else(drv == "4", 1, 0))
```

## 1. Validación: train/test y validación cruzada básica

Ajustar un modelo y evaluarlo con los mismos datos con los que lo entrenaste sobreestima qué tan bien va a generalizar. La práctica estándar es separar una porción de los datos (típicamente 20-30%) que el modelo nunca ve durante el ajuste.

```r
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
```

La matriz de confusión sobre el conjunto de prueba te da más detalle que la exactitud sola — cuántos falsos positivos y falsos negativos comete el modelo:

```r
table(observado = test$traccion_4wd, predicho = clase_test)
```

Un único split train/test depende de qué observaciones cayeron de cada lado por azar. La **validación cruzada k-fold** promedia el desempeño sobre varios splits para dar una estimación más estable:

```r
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
```

## 2. broom para reportar resultados de forma ordenada

Una gráfica de coeficientes (u odds ratios, en este caso) con sus intervalos de confianza suele comunicar un modelo mejor que una tabla de números:

```r
modelo_final <- glm(traccion_4wd ~ displ + cyl + hwy, data = datos, family = binomial)

tidy(modelo_final, conf.int = TRUE, exponentiate = TRUE) %>%
  filter(term != "(Intercept)") %>%
  ggplot(aes(x = fct_reorder(term, estimate), y = estimate)) +
  geom_pointrange(aes(ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "red") +
  coord_flip() +
  labs(title = "Odds ratios con IC 95%", x = NULL, y = "Odds ratio") +
  theme_minimal()
```

## Ejemplo: comparar dos modelos con validación cruzada

La validación cruzada no es solo para reportar un número — sirve para **decidir** entre modelos candidatos de forma más confiable que comparar su ajuste sobre los mismos datos con los que se entrenaron.

```r
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
```

Convertir la lógica de validación cruzada en una función que recibe la **fórmula** como argumento es lo que la hace reutilizable: puedes comparar tantos modelos candidatos como quieras sin copiar y pegar el bloque de código de arriba cada vez — exactamente el tipo de composición de funciones que viste en el [capítulo 5](capitulo05_proyectos_reproducibles.md).

## Mini-proyecto integrador (entrega del curso)

Elige un dataset (puede ser uno de los incluidos en R —como `diamonds`, `txhousing`, `starwars`— o uno propio de tu área) y entrega un documento Quarto (`.qmd`) renderizado a HTML que incluya:

1. **Descripción breve** del dataset y la pregunta que quieres responder.
2. **Limpieza/transformación** de datos con dplyr/tidyr.
3. **Al menos 2 visualizaciones** con ggplot2 que exploren la pregunta.
4. **Un modelo** (`lm` o `glm`) que aborde la pregunta, con:
   - tabla de coeficientes (`tidy()`)
   - una gráfica de diagnóstico o de efectos
   - 3-5 líneas interpretando los resultados en el contexto del problema
5. Una sección de **limitaciones** (qué no captura el modelo).

Extensión sugerida: 3-5 páginas renderizadas. Se evalúa reproducibilidad (el `.qmd` debe correr de principio a fin sin errores) y claridad de la interpretación — no la complejidad del modelo.

## Ejercicios

1. Calcula la matriz de confusión y la exactitud del modelo del ejercicio 1 del capítulo 9 (`am ~ hp + wt` en `mtcars`), usando todos los datos como entrenamiento.
2. **Reto:** implementa validación cruzada de 5 folds para ese mismo modelo logístico sobre `mtcars` y reporta la exactitud promedio.
3. Usa `comparar_modelo_cv()` del ejemplo para evaluar un tercer modelo, `traccion_4wd ~ displ + class`, y decide cuál de los tres modelos (simple, completo, con `class`) tiene mejor exactitud promedio.
4. **Reto:** modifica `comparar_modelo_cv()` para que además regrese la desviación estándar de las exactitudes entre folds (no solo el promedio) — un modelo con exactitud promedio similar pero menor variación entre folds es, en general, preferible.

## Fin del curso

A partir de aquí continúas directo con Modelación Estadística. El mini-proyecto integrador se entrega al cierre de esta sesión. ¡Buen trabajo!

---

[← Capítulo 9](capitulo09_glm.md) · [Índice](../../README.md)
