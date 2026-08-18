# Capítulo 7 — Regresión lineal

**Sesión 7 · Día 4, mañana · 2 horas**
Script de práctica: [`sesiones/sesion07_regresion_lineal.R`](../../sesiones/sesion07_regresion_lineal.R)

[← Capítulo 6](capitulo06_computo_simulacion.md) · [Índice](../../README.md) · [Capítulo 8 →](capitulo08_diagnostico_anova.md)

## Objetivo

Interpretar la notación de fórmula de R, ajustar modelos con `lm()`, leer la salida de `summary()`, y trabajar con factores y niveles de referencia. Aquí arranca la parte de modelación estadística del curso.

```r
library(tidyverse)
library(broom)

datos <- as_tibble(mpg)
```

## 1. La notación de fórmula: y ~ x

Toda la modelación en R (lineal, generalizada, y buena parte de los modelos estadísticos del ecosistema) comparte la misma notación de fórmula:

| Fórmula | Significado |
|---|---|
| `y ~ x1 + x2` | modelo aditivo con dos predictores |
| `y ~ x1 * x2` | `x1 + x2` + interacción `x1:x2` |
| `y ~ x1 + x2 - 1` | sin intercepto |
| `y ~ .` | todas las demás columnas como predictoras |

```r
modelo_simple <- lm(hwy ~ displ, data = datos)
modelo_simple
```

## 2. summary(): la salida estándar de un modelo

```r
summary(modelo_simple)
```

Las piezas clave de esa salida:

- **Estimate:** los coeficientes estimados (pendiente e intercepto).
- **Std. Error, t value, Pr(>|t|):** la prueba de significancia de cada coeficiente.
- **Multiple R-squared / Adjusted R-squared:** qué tan bien ajusta el modelo.
- **F-statistic:** la prueba global de que el modelo, en conjunto, explica algo.

`broom::tidy()` da exactamente la misma información pero en formato tibble — mucho más cómodo para programar, filtrar o graficar que el texto de `summary()`:

```r
tidy(modelo_simple, conf.int = TRUE)
glance(modelo_simple)     # métricas de resumen (R2, AIC, BIC, etc.) en una fila
```

## 3. Modelo múltiple y factores

```r
modelo_multi <- lm(hwy ~ displ + cyl + class, data = datos)
summary(modelo_multi)
```

`class` es una variable de texto, y `lm()` la convierte automáticamente en un factor. R elige un nivel de referencia (por default, el primero en orden alfabético) y reporta los demás niveles como **diferencias respecto a ese nivel de referencia**:

```r
levels(factor(datos$class))
contrasts(factor(datos$class))     # matriz de contrastes tipo "treatment"
```

Si el nivel de referencia por default no es el más útil para tu interpretación (por ejemplo, quieres comparar todo contra la categoría "midsize" en vez de la primera alfabética), puedes cambiarlo con `relevel()`:

```r
datos_relevel <- datos %>% mutate(class = relevel(factor(class), ref = "midsize"))
modelo_relevel <- lm(hwy ~ class, data = datos_relevel)
tidy(modelo_relevel)
```

Esto no cambia el ajuste del modelo — solo cambia respecto a qué categoría se interpretan los coeficientes.

## Ejercicios

1. Ajusta `lm(hwy ~ cty, data = datos)`. Interpreta la pendiente: ¿cuánto cambia `hwy` por cada unidad de `cty`?
2. Agrega `year` como predictor adicional (como factor) a `modelo_multi`. ¿Es significativo? Revisa su p-value con `tidy()`.

---

[← Capítulo 6](capitulo06_computo_simulacion.md) · [Índice](../../README.md) · [Capítulo 8 →](capitulo08_diagnostico_anova.md)
