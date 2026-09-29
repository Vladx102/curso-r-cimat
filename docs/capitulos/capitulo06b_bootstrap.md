# Capítulo 6b — Bootstrap

**Sesión 6b · 2 horas**
Script de práctica: [`sesiones/sesion06b_bootstrap.R`](../../sesiones/sesion06b_bootstrap.R)

[← Capítulo 6](capitulo06_computo_simulacion.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)

## Objetivo

Entender el bootstrap como técnica de remuestreo para aproximar la distribución muestral de un estadístico sin depender de supuestos paramétricos, construir intervalos de confianza bootstrap (método percentil), y aplicarlo a estadísticos sin fórmula cerrada simple (mediana, correlación, diferencia de medias).

```r
library(tidyverse)
```

## 1. ¿Qué es bootstrap? Remuestreo con reemplazo

La idea detrás del bootstrap es engañosamente simple: tratas la muestra que ya tienes como si fuera la población entera, y sacas remuestras del mismo tamaño **con reemplazo**. Cada remuestra es como un universo paralelo donde, por azar, algunas observaciones se repiten y otras no aparecen.

```r
set.seed(2026)
x <- mtcars$mpg

remuestra <- sample(x, size = length(x), replace = TRUE)
remuestra
```

`replace = TRUE` es la clave — es justo lo que ya usaste en la sesión 6 para simular lanzamientos de moneda o dado, solo que ahora remuestreas tus propios datos en vez de generar valores nuevos.

## 2. Bootstrap manual con replicate()

Repites el remuestreo miles de veces, calculando el estadístico de interés (por ejemplo, la media) en cada una — el mismo patrón `replicate()` que ya usaste para simular el poder de una prueba en la sesión 6.

```r
set.seed(2026)
B <- 2000   # número de remuestras
medias_boot <- replicate(B, mean(sample(x, replace = TRUE)))

hist(medias_boot, breaks = 40, col = "steelblue", main = "Distribución bootstrap de la media")
mean(medias_boot)   # se acerca a mean(x)
sd(medias_boot)      # "error estándar bootstrap"
```

El histograma de `medias_boot` **es** una aproximación empírica a la distribución muestral de la media — la misma idea que exploraste con el Teorema del Límite Central, pero construida directamente a partir de tus datos en vez de una fórmula teórica.

## 3. Intervalo de confianza bootstrap (método percentil)

El método más simple para construir un intervalo de confianza a partir de `medias_boot` es tomar los percentiles 2.5% y 97.5% de esa distribución bootstrap:

```r
quantile(medias_boot, probs = c(0.025, 0.975))
```

Compáralo contra el intervalo clásico, que asume que la media muestral se distribuye normalmente:

```r
t.test(x)$conf.int
```

Con una muestra razonablemente grande y una variable poco asimétrica, ambos intervalos suelen parecerse mucho — el bootstrap no está "mal" el resto del tiempo, simplemente no necesita la suposición de normalidad para funcionar.

## 4. Bootstrap para otros estadísticos: mediana

Aquí es donde el bootstrap empieza a brillar de verdad: no existe una fórmula cerrada simple para el error estándar de la mediana, pero el bootstrap no la necesita — el procedimiento es exactamente el mismo, solo cambias la función:

```r
set.seed(2026)
medianas_boot <- replicate(B, median(sample(x, replace = TRUE)))
quantile(medianas_boot, probs = c(0.025, 0.975))
```

## 5. Bootstrap "por filas": estadísticos entre dos variables

Para un estadístico que involucra la relación entre dos variables, como la correlación, no puedes remuestrear cada vector por separado — eso rompería la relación entre ellas. En vez de eso, remuestreas **filas completas**, manteniendo cada par `(mpg, hp)` unido:

```r
n <- nrow(mtcars)
set.seed(2026)
cors_boot <- replicate(B, {
  filas <- sample(1:n, size = n, replace = TRUE)
  muestra <- mtcars[filas, ]
  cor(muestra$mpg, muestra$hp)
})

quantile(cors_boot, probs = c(0.025, 0.975))
cor(mtcars$mpg, mtcars$hp)   # el valor observado, para comparar
```

Este patrón — remuestrear índices de fila con `sample(1:n, ..., replace = TRUE)` y luego indexar el data frame completo — es la forma general de hacer bootstrap sobre cualquier estadístico que combine varias columnas, no solo la correlación.

## Ejercicios

1. Calcula un intervalo de confianza bootstrap (percentil, `B = 2000`) para la desviación estándar de `mtcars$hp`.
2. Calcula un intervalo de confianza bootstrap para la correlación entre `wt` y `mpg` en `mtcars` (remuestreando filas, como en la sección 5).
3. Importa [`data/clima.csv`](../../data/clima.csv) y compara el intervalo de confianza bootstrap para la media de `precipitacion_mm` contra el de `t.test()`. ¿Son parecidos? (Pista: precipitación suele ser una variable asimétrica.)
4. **Reto:** simula dos muestras normales `grupo1` y `grupo2` (como en la sesión 6) y calcula un intervalo de confianza bootstrap para la diferencia de medias (`mean(grupo1) - mean(grupo2)`), remuestreando cada grupo por separado dentro de un solo `replicate()`. Compáralo con el intervalo de `t.test(grupo1, grupo2)`.

## Ejemplo: bootstrap sobre datos reales — diferencia de temperatura

Cierra el círculo con el `t.test(temperatura_c ~ ciudad)` de la sesión 6, pero ahora con un intervalo de confianza bootstrap para la misma diferencia.

```r
clima <- read_csv("data/clima.csv")

diferencia_temp <- function(datos) {
  medias <- tapply(datos$temperatura_c, datos$ciudad, mean)
  medias[1] - medias[2]
}

diferencia_temp(clima)   # diferencia observada, sin remuestrear
```

`diferencia_temp()` reutiliza `tapply()` (sesión 2) para calcular la media por ciudad y restarlas — envolver el cálculo en una función es lo que permite reusarlo dentro de `replicate()` sobre cada remuestra:

```r
n_clima <- nrow(clima)
set.seed(2026)
dif_boot <- replicate(B, {
  filas <- sample(1:n_clima, size = n_clima, replace = TRUE)
  diferencia_temp(clima[filas, ])
})

quantile(dif_boot, probs = c(0.025, 0.975))
```

Y lo comparamos contra el intervalo de confianza clásico que ya calculaste en la sesión 6:

```r
t.test(temperatura_c ~ ciudad, data = clima)$conf.int
```

5. Usando el mismo patrón de "remuestrear filas + función propia", calcula un intervalo de confianza bootstrap para la diferencia de precipitación promedio entre las dos ciudades de `clima.csv`.
6. **Reto:** escribe una función `bootstrap_ic(x, FUN, B = 2000, conf = 0.95)` que reciba un vector, una función (`mean`, `median`, `sd`...) y regrese el intervalo de confianza bootstrap para ese estadístico. Pruébala con al menos dos funciones distintas sobre `mtcars$qsec`.

---

[← Capítulo 6](capitulo06_computo_simulacion.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)
