# Capítulo 6 — Cómputo estadístico y simulación

**Sesión 6 · Día 3, tarde · 2 horas**
Script de práctica: [`sesiones/sesion06_computo_simulacion.R`](../../sesiones/sesion06_computo_simulacion.R)

[← Capítulo 5](capitulo05_proyectos_reproducibles.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)

## Objetivo

Usar la familia `d`/`p`/`q`/`r` para trabajar con distribuciones de probabilidad, fijar semillas para reproducibilidad, simular experimentos con Monte Carlo, generar datasets ficticios, resumir datos con las herramientas de estadística descriptiva de R (`quantile`, `IQR`, `cor`, `cov`, y `skimr::skim()`), y dar el primer paso hacia inferencia con `t.test()`.

```r
library(tidyverse)
library(skimr)      # resúmenes descriptivos rápidos de un data frame completo

# Función del capítulo anterior, la reutilizamos aquí:
error_estandar <- function(x, na.rm = TRUE) {
  n <- if (na.rm) sum(!is.na(x)) else length(x)
  sd(x, na.rm = na.rm) / sqrt(n)
}
```

## 1. Distribuciones en R: la familia d/p/q/r

Para cada distribución de probabilidad que R conoce (`norm`, `binom`, `pois`, `unif`, `t`, `chisq`, `exp`, ...) existen cuatro funciones con un patrón de nombre consistente:

| Prefijo | Qué regresa | Ejemplo |
|---|---|---|
| `d<dist>()` | densidad / masa de probabilidad | `dnorm(0)` |
| `p<dist>()` | función de distribución acumulada (CDF) | `pnorm(1.96)` |
| `q<dist>()` | cuantil (inversa de la CDF) | `qnorm(0.975)` |
| `r<dist>()` | números aleatorios simulados | `rnorm(10)` |

```r
dnorm(0, mean = 0, sd = 1)          # altura de la densidad normal en 0
pnorm(1.96)                          # P(Z <= 1.96) ≈ 0.975
qnorm(0.975)                         # cuantil 97.5% ≈ 1.96
rnorm(5, mean = 100, sd = 15)        # 5 valores aleatorios N(100, 15^2)

# Mismo patrón para binomial, Poisson, etc.
dbinom(3, size = 10, prob = 0.5)     # P(X = 3) con X ~ Binomial(10, 0.5)
ppois(5, lambda = 3)                 # P(X <= 5) con X ~ Poisson(3)
```

Una vez que memorizas este patrón, trabajar con cualquier distribución nueva en R es cuestión de saber su nombre (`gamma`, `beta`, `weibull`...), no de aprender una API distinta.

## 2. Números aleatorios y reproducibilidad

`set.seed()` fija el generador de números pseudoaleatorios de R, lo que garantiza reproducibilidad total: cualquiera que corra tu script con la misma semilla obtiene exactamente los mismos "números aleatorios".

```r
set.seed(2026)
rnorm(3)
set.seed(2026)
rnorm(3)             # idéntico al anterior
```

Fijar la semilla al inicio de cualquier simulación es una práctica no negociable en análisis reproducible — sin ella, tus resultados no se pueden verificar ni reproducir.

## 3. Simulación Monte Carlo

**Ejemplo 1 — Ley de los grandes números.** Simulamos 10,000 lanzamientos de una moneda justa y observamos cómo la proporción acumulada de éxitos converge a 0.5 conforme crece `n`.

```r
set.seed(1)
lanzamientos <- sample(c(0, 1), size = 10000, replace = TRUE, prob = c(0.5, 0.5))
medias_acumuladas <- cumsum(lanzamientos) / seq_along(lanzamientos)

tibble(n = seq_along(medias_acumuladas), media = medias_acumuladas) %>%
  ggplot(aes(n, media)) +
  geom_line() +
  geom_hline(yintercept = 0.5, color = "red", linetype = "dashed") +
  labs(title = "Ley de los grandes números", x = "n", y = "Proporción acumulada de éxitos") +
  theme_minimal()
```

**Ejemplo 2 — Teorema del límite central.** Tomamos muchas muestras de una distribución exponencial (muy asimétrica) y observamos que la distribución de sus *medias muestrales* se vuelve aproximadamente normal, aunque la población original no lo sea.

```r
set.seed(1)
n_muestra <- 30
n_repeticiones <- 5000

medias <- replicate(n_repeticiones, mean(rexp(n_muestra, rate = 1)))

tibble(medias) %>%
  ggplot(aes(medias)) +
  geom_histogram(aes(y = after_stat(density)), bins = 40, fill = "steelblue", alpha = 0.7) +
  stat_function(fun = dnorm, args = list(mean = mean(medias), sd = sd(medias)), color = "red") +
  labs(title = "CLT: distribución de medias muestrales de Exp(1)", x = "media muestral") +
  theme_minimal()
```

El Teorema del Límite Central se entiende mucho mejor simulándolo, viendo el histograma converger a una campana, que memorizando su enunciado formal.

## 4. Generar datos ficticios para practicar

No siempre necesitas un dataset real para practicar dplyr o ggplot2: puedes construir uno ficticio combinando `sample()`, secuencias de fechas y las funciones `r<dist>()` que ya viste. Es la manera más rápida de tener datos "de mentira" con exactamente la forma que quieras (tipos de columna, proporciones de categorías, tamaño de muestra).

```r
set.seed(42)
n <- 200

datos_ficticios <- tibble(
  id        = sprintf("ID%03d", 1:n),                                    # identificador secuencial
  fecha     = sample(seq(as.Date("2024-01-01"), as.Date("2024-12-31"),
                          by = "day"), n, replace = TRUE),                # fechas aleatorias en un rango
  categoria = sample(c("A", "B", "C"), n, replace = TRUE,
                      prob = c(0.5, 0.3, 0.2)),                          # categorías con probabilidades distintas
  cliente   = sample(c("Ana", "Luis", "Marta", "Iván", "Sofía"), n,
                      replace = TRUE),                                   # nombres ficticios (con repetición)
  monto     = round(rgamma(n, shape = 2, rate = 0.1), 2)                 # numérica asimétrica (p.ej. montos de compra)
)

datos_ficticios
table(datos_ficticios$categoria)          # verifica que las proporciones cuadran aprox.
```

El argumento `prob` de `sample()` controla qué tan probable es cada categoría; sin él, `sample()` asume que todas las opciones son igual de probables. Este mismo patrón — combinar `sample()`, fechas y funciones `r<dist>()` dentro de un `tibble()` — es el que vas a reutilizar más adelante para generar predictores antes de ajustar un modelo (sesiones 7 en adelante).

## 5. Estadística descriptiva: resumen numérico

Más allá de `mean()`/`sd()`, estas son las funciones que vas a usar todo el tiempo para resumir una variable numérica.

```r
x <- mtcars$mpg

summary(x)                            # resumen de 6 números: min, Q1, mediana, media, Q3, max
quantile(x)                           # cuartiles (0%, 25%, 50%, 75%, 100%)
quantile(x, probs = c(0.1, 0.9))      # cuantiles arbitrarios
IQR(x)                                # rango intercuartílico: Q3 - Q1 (dispersión robusta)
```

`cor()`/`cov()` describen la relación **entre dos** variables numéricas — covarianza y correlación de Pearson:

```r
cor(mtcars$mpg, mtcars$hp)     # correlación de Pearson, entre -1 y 1
cov(mtcars$mpg, mtcars$hp)     # covarianza (misma idea, sin normalizar a [-1, 1])

# cor() sobre varias columnas a la vez da la matriz de correlaciones
cor(mtcars[, c("mpg", "hp", "wt")])
```

**skimr::skim()** automatiza todo lo anterior de un jalón: para cada columna de un data frame completo, da media, sd, cuartiles, histograma en texto, porcentaje de `NA`s, etc. Es el punto de partida típico al explorar un dataset nuevo.

```r
skim(mtcars[, c("mpg", "hp", "wt")])
```

## 6. Introducción a la inferencia: t.test()

`t.test()` hace una prueba t y, de paso, regresa el intervalo de confianza para la media — ya no hace falta calcularlo a mano con `error_estandar()`.

```r
set.seed(2026)
muestra <- rnorm(30, mean = 100, sd = 15)

prueba <- t.test(muestra, mu = 95)   # H0: la media poblacional es 95
prueba
prueba$p.value          # valor p
prueba$conf.int         # intervalo de confianza (95% por default)
```

También sirve para comparar dos grupos (dos muestras independientes):

```r
grupo1 <- rnorm(20, mean = 50, sd = 5)
grupo2 <- rnorm(20, mean = 53, sd = 5)

t.test(grupo1, grupo2, var.equal = TRUE)    # asumiendo varianzas iguales
t.test(grupo1, grupo2, var.equal = FALSE)   # prueba de Welch (varianzas distintas; es el default)
```

`var.equal = FALSE` (prueba de Welch) es el default de R porque asumir varianzas iguales cuando no lo son infla el error tipo I — cuando tengas duda, deja el default.

## Ejercicios

1. Usando `qnorm()`, encuentra el valor crítico de una normal estándar para un intervalo de confianza del 90%.
2. Simula 10,000 lanzamientos de un dado justo (`sample(1:6, ...)`) y verifica con una tabla (`table()`/`prop.table()`) que cada cara aparece aproximadamente 1/6 de las veces.
3. Escribe una función `intervalo_confianza_media(x, conf = 0.95)` que reciba un vector y regrese el intervalo de confianza para la media usando la aproximación normal: `media +/- z * error_estandar(x)`.
4. **Reto:** repite la simulación del CLT del ejemplo 2 pero partiendo de una distribución uniforme (`runif`) y de una binomial con `p = 0.05` (muy asimétrica). ¿Con qué tamaño de muestra `n` empieza a verse razonablemente normal en cada caso?
5. Genera tu propio dataset ficticio con al menos 4 columnas (incluyendo una fecha y una variable categórica) y `n = 150` filas. Usa `table()`/`prop.table()` para verificar que las categorías respetan aproximadamente las probabilidades que definiste en el `prob` de `sample()`.
6. Usando `mtcars$wt`, calcula el resumen de 5 números (`quantile()`), el IQR, y determina si hay valores atípicos con la regla `Q1 - 1.5*IQR` / `Q3 + 1.5*IQR`. ¿Cuál es la correlación entre `wt` y `mpg`? ¿Tiene sentido el signo?
7. Simula dos muestras normales con medias distintas (`rnorm`) y usa `t.test()` para probar si la diferencia de medias es significativa. Repite con medias iguales: ¿cambia el valor p como esperabas?

## Ejemplo: simular y analizar un experimento A/B

Combina simulación, estadística descriptiva y `t.test()` en un solo flujo: el tipo de análisis que harías con datos reales de un experimento.

```r
set.seed(7)
n_por_grupo <- 40

# Simulamos un experimento: el grupo B (una versión nueva de una página web)
# tiene un tiempo de conversión ligeramente menor (mejor) que el grupo A.
tiempo_A <- rnorm(n_por_grupo, mean = 45, sd = 12)   # segundos, versión actual
tiempo_B <- rnorm(n_por_grupo, mean = 40, sd = 12)   # segundos, versión nueva

experimento <- tibble(
  grupo = rep(c("A", "B"), each = n_por_grupo),
  tiempo = c(tiempo_A, tiempo_B)
)

# Resumen descriptivo por grupo
experimento %>%
  group_by(grupo) %>%
  summarize(n = n(), media = mean(tiempo), mediana = median(tiempo),
            sd = sd(tiempo), IQR = IQR(tiempo))
```

Visualizar antes de probar formalmente siempre vale la pena — un boxplot te da una intuición inmediata de si la diferencia es grande frente a la variabilidad dentro de cada grupo:

```r
ggplot(experimento, aes(x = grupo, y = tiempo, fill = grupo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Tiempo de conversión por grupo del experimento", y = "segundos") +
  theme_minimal()
```

`t.test()` también acepta notación de fórmula (`variable ~ grupo`) en vez de dos vectores separados — la misma notación `y ~ x` que vas a usar con `lm()`/`glm()` a partir del [capítulo 7](capitulo07_regresion_lineal.md):

```r
t.test(tiempo ~ grupo, data = experimento)
```

8. Cambia la media de `tiempo_B` a 44 (una diferencia más chica) y repite el `t.test()`. ¿Sigue siendo significativa la diferencia? ¿Qué pasó con el valor p?
9. **Reto:** repite el experimento completo 500 veces (con `replicate()`) variando los datos simulados cada vez, y calcula en qué proporción de las repeticiones el `t.test()` detectó una diferencia significativa (`p < 0.05`) cuando las medias reales son 45 y 40 — esto es, informalmente, el "poder" de la prueba.

---

[← Capítulo 5](capitulo05_proyectos_reproducibles.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)
