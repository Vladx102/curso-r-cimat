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

## Ejemplos

### Ejemplo 1: diferencia de temperatura entre ciudades

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

### Ejemplo 2: ver la distribución bootstrap — mediana del monto de venta

Un intervalo son solo dos números; el histograma de la distribución bootstrap muestra de dónde salen. Aquí se calcula la mediana del `monto` en `ventas.csv` para 2000 remuestras:

```r
ventas <- read_csv("data/ventas.csv")

set.seed(2026)
medianas_monto <- replicate(B, median(sample(ventas$monto, replace = TRUE)))
ic_mediana <- quantile(medianas_monto, probs = c(0.025, 0.975))
ic_mediana
```

Y se grafica marcando la mediana observada (línea sólida) y los límites del intervalo (líneas punteadas):

```r
tibble(mediana = medianas_monto) %>%
  ggplot(aes(mediana)) +
  geom_histogram(bins = 40, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = median(ventas$monto), color = "red") +            # mediana observada
  geom_vline(xintercept = ic_mediana, color = "red", linetype = "dashed") + # límites del IC
  labs(title = "Distribución bootstrap de la mediana del monto",
       x = "mediana de la remuestra", y = "frecuencia") +
  theme_minimal()
```

El 95% de las medianas remuestreadas cae entre las dos líneas punteadas — eso *es* el intervalo percentil. El histograma no es una campana suave: la mediana de una remuestra solo puede tomar valores que ya están en los datos (o el promedio de dos de ellos), por eso aparecen picos.

### Ejemplo 3: una proporción — préstamos sin devolver

Una proporción es la media de un vector lógico (`TRUE` cuenta como 1 y `FALSE` como 0), así que el procedimiento es el mismo que para la media. En `prestamos.csv`, un préstamo sin devolver tiene `NA` en `fecha_devolucion`:

```r
prestamos <- read_csv("data/prestamos.csv")

sin_devolver <- is.na(prestamos$fecha_devolucion)   # TRUE/FALSE por préstamo
mean(sin_devolver)                                  # proporción observada

set.seed(2026)
prop_boot <- replicate(B, mean(sample(sin_devolver, replace = TRUE)))
quantile(prop_boot, probs = c(0.025, 0.975))
```

### Ejemplo 4: estadístico propio con una muestra chica — coeficiente de variación

El coeficiente de variación (`sd / media`) mide la dispersión relativa y no tiene una fórmula sencilla para su intervalo de confianza. Con bootstrap basta escribir la función y usarla dentro de `replicate()`:

```r
empleados <- read_csv("data/empleados.csv")

coef_variacion <- function(v) sd(v) / mean(v)
coef_variacion(empleados$salario)

set.seed(2026)
cv_boot <- replicate(B, coef_variacion(sample(empleados$salario, replace = TRUE)))
quantile(cv_boot, probs = c(0.025, 0.975))
```

`empleados.csv` solo tiene 25 filas, y eso se nota en lo ancho del intervalo: el bootstrap no inventa información, solo usa la que hay en la muestra. Con muestras muy chicas el intervalo es ancho y además menos confiable.

### Ejemplo 5: ¿cuántas remuestras `B`?

Como el bootstrap es aleatorio, dos corridas con semillas distintas dan intervalos ligeramente distintos. Para ver cuánto cambian, se repite 20 veces el cálculo del límite inferior del IC de la media de `mtcars$mpg` para cada valor de `B`:

```r
limite_inferior <- function(b) {
  quantile(replicate(b, mean(sample(x, replace = TRUE))), probs = 0.025)
}

set.seed(2026)
estabilidad <- tibble(
  remuestras = rep(c(50, 200, 1000, 5000), each = 20),   # 20 repeticiones por cada B
  limite     = sapply(remuestras, limite_inferior)
)

ggplot(estabilidad, aes(factor(remuestras), limite)) +
  geom_jitter(width = 0.1, color = "steelblue", alpha = 0.7) +
  labs(title = "Límite inferior del IC en 20 repeticiones, según B",
       x = "B (número de remuestras)", y = "límite inferior (2.5%)") +
  theme_minimal()
```

Con `B = 50` el límite cambia bastante entre repeticiones; con `B = 1000` o más casi no se mueve. Por eso se usan miles de remuestras: aumentar `B` no hace el intervalo más angosto (eso depende del tamaño de la muestra), solo lo hace más estable.

## Ejercicios (continuación)

5. Usando el mismo patrón de "remuestrear filas + función propia", calcula un intervalo de confianza bootstrap para la diferencia de precipitación promedio entre las dos ciudades de `clima.csv`.
6. **Reto:** escribe una función `bootstrap_ic(x, FUN, B = 2000, conf = 0.95)` que reciba un vector, una función (`mean`, `median`, `sd`...) y regrese el intervalo de confianza bootstrap para ese estadístico. Pruébala con al menos dos funciones distintas sobre `mtcars$qsec`.
7. Los tiempos de espera (en minutos) de 20 clientes en una ventanilla fueron `espera <- c(3, 5, 4, 7, 2, 6, 4, 5, 3, 8, 4, 6, 5, 3, 7, 4, 5, 42, 6, 4)`. Calcula un intervalo de confianza bootstrap para la media y otro para la mediana. ¿Cuál es más ancho? ¿Qué valor de los datos lo explica?
8. Con `setosa <- iris$Sepal.Length[iris$Species == "setosa"]`, calcula un intervalo de confianza bootstrap para la mediana y grafica el histograma de la distribución bootstrap, marcando con líneas verticales la mediana observada y los dos límites del intervalo.
9. En `mtcars`, `am == 1` indica transmisión manual. Calcula un intervalo de confianza bootstrap para la proporción de autos manuales.
10. Importa [`data/libros.csv`](../../data/libros.csv) y calcula un intervalo de confianza bootstrap para el percentil 90 de `num_paginas` (`quantile(v, 0.9)`).
11. Corre `set.seed(10)`, luego `muestra_chica <- rexp(15, rate = 1 / 20)` y `muestra_grande <- rexp(150, rate = 1 / 20)` (en ese orden, para que todos tengan los mismos datos). Calcula el intervalo de confianza bootstrap para la media de cada una y compara sus anchos con `diff()`. ¿Qué pasa al tener más datos?
12. **Reto:** calcula la distribución bootstrap del máximo de `mtcars$mpg` y revísala con `table()`. ¿Por qué toma tan pocos valores distintos? ¿Es confiable un intervalo de confianza construido así?

---

[← Capítulo 6](capitulo06_computo_simulacion.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)
