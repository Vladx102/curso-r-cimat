# Capítulo 6 — Cómputo estadístico y simulación

**Sesión 6 · Día 3, tarde · 2 horas**
Script de práctica: [`sesiones/sesion06_computo_simulacion.R`](../../sesiones/sesion06_computo_simulacion.R)

[← Capítulo 5](capitulo05_proyectos_reproducibles.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)

## Objetivo

Usar la familia `d`/`p`/`q`/`r` para trabajar con distribuciones de probabilidad, fijar semillas para reproducibilidad, y simular experimentos con Monte Carlo.

```r
library(tidyverse)

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

## Ejercicios

1. Usando `qnorm()`, encuentra el valor crítico de una normal estándar para un intervalo de confianza del 90%.
2. Simula 10,000 lanzamientos de un dado justo (`sample(1:6, ...)`) y verifica con una tabla (`table()`/`prop.table()`) que cada cara aparece aproximadamente 1/6 de las veces.
3. Escribe una función `intervalo_confianza_media(x, conf = 0.95)` que reciba un vector y regrese el intervalo de confianza para la media usando la aproximación normal: `media +/- z * error_estandar(x)`.
4. **Reto:** repite la simulación del CLT del ejemplo 2 pero partiendo de una distribución uniforme (`runif`) y de una binomial con `p = 0.05` (muy asimétrica). ¿Con qué tamaño de muestra `n` empieza a verse razonablemente normal en cada caso?

---

[← Capítulo 5](capitulo05_proyectos_reproducibles.md) · [Índice](../../README.md) · [Capítulo 7 →](capitulo07_regresion_lineal.md)
