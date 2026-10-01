# =============================================================================
# Sesión 6 — Día 3 · tarde — Cómputo estadístico y simulación
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Usar la familia d/p/q/r para trabajar con distribuciones, fijar semillas
#   para reproducibilidad, simular experimentos con Monte Carlo, generar
#   datasets ficticios (fechas, categorías, IDs), resumir datos con las
#   herramientas de estadística descriptiva de R (quantile, IQR, cor, cov,
#   skimr::skim()), y dar el primer paso hacia inferencia con t.test().

library(tidyverse)
library(skimr)      # resúmenes descriptivos rápidos de un data frame completo

# Función de la sesión anterior, la reutilizamos aquí:
error_estandar <- function(x, na.rm = TRUE) {
  n <- if (na.rm) sum(!is.na(x)) else length(x)
  sd(x, na.rm = na.rm) / sqrt(n)
}

# -----------------------------------------------------------------------------
# 1. Distribuciones en R: la familia d/p/q/r
# -----------------------------------------------------------------------------
# Para cada distribución (norm, binom, pois, unif, t, chisq, exp, ...) hay
# cuatro funciones:
#   d<dist>()  densidad / masa de probabilidad         dnorm(0)
#   p<dist>()  función de distribución acumulada (CDF)  pnorm(1.96)
#   q<dist>()  cuantil (inversa de la CDF)               qnorm(0.975)
#   r<dist>()  generación de números aleatorios          rnorm(10)

dnorm(0, mean = 0, sd = 1)          # altura de la densidad normal en 0
pnorm(1.96)                          # P(Z <= 1.96) ≈ 0.975
qnorm(0.975)                         # cuantil 97.5% ≈ 1.96
rnorm(5, mean = 100, sd = 15)        # 5 valores aleatorios N(100, 15^2)

# Mismo patrón para binomial, Poisson, etc.
dbinom(3, size = 10, prob = 0.5)     # P(X = 3) con X ~ Binomial(10, 0.5)
ppois(5, lambda = 3)                 # P(X <= 5) con X ~ Poisson(3)

# Discreta, X ~ Binomial(10, 0.5): número de águilas en 10 volados
# d = función de masa P(X = k)
dbinom(3, size = 10, prob = 0.5)             # P(X = 3)
dbinom(0:10, size = 10, prob = 0.5)          # toda la función de masa, k = 0, ..., 10
sum(dbinom(0:10, size = 10, prob = 0.5))     # suma 1

# p = función acumulada P(X <= k); de ella salen las demás probabilidades
pbinom(3, size = 10, prob = 0.5)             # P(X <= 3)
sum(dbinom(0:3, size = 10, prob = 0.5))      # lo mismo: la acumulada es la suma de la masa

1 - pbinom(3, size = 10, prob = 0.5)                    # P(X > 3)
pbinom(3, size = 10, prob = 0.5, lower.tail = FALSE)    # lo mismo, sin restar
pbinom(5, 10, 0.5) - pbinom(1, 10, 0.5)                 # P(2 <= X <= 5): se resta P(X <= 1), no P(X <= 2)

# q = cuantil
qbinom(0.5, size = 10, prob = 0.5)           # mediana: el k más chico con P(X <= k) >= 0.5

# La masa y la acumulada en gráfica
dist_binomial <- tibble(
  k         = 0:10,
  masa      = dbinom(k, size = 10, prob = 0.5),
  acumulada = pbinom(k, size = 10, prob = 0.5)
)

ggplot(dist_binomial, aes(k, masa)) +
  geom_col(fill = "steelblue") +
  scale_x_continuous(breaks = 0:10) +
  labs(title = "Función de masa: Binomial(10, 0.5)", y = "P(X = k)") +
  theme_minimal()

ggplot(dist_binomial, aes(k, acumulada)) +
  geom_step() +                        # escalón: la acumulada salta en cada k
  geom_point() +
  scale_x_continuous(breaks = 0:10) +
  labs(title = "Función acumulada: Binomial(10, 0.5)", y = "P(X <= k)") +
  theme_minimal()

# Continua, X ~ Normal(100, 15): d es una altura; las probabilidades salen de p
dnorm(100, mean = 100, sd = 15)              # altura de la curva en 100 (no es probabilidad)

pnorm(115, mean = 100, sd = 15)              # P(X <= 115)
1 - pnorm(115, mean = 100, sd = 15)          # P(X > 115)
pnorm(115, 100, 15) - pnorm(85, 100, 15)     # P(85 < X < 115)

qnorm(0.90, mean = 100, sd = 15)             # percentil 90
pnorm(qnorm(0.90, 100, 15), 100, 15)         # q y p son inversas: regresa 0.90

# ¿Dónde caen los valores simulados? Densidad teórica + la muestra encima
set.seed(2026)
muestra_normal <- rnorm(30, mean = 100, sd = 15)

ggplot(tibble(x = muestra_normal), aes(x = x)) +
  stat_function(fun = dnorm, args = list(mean = 100, sd = 15), color = "steelblue", linewidth = 1) +
  geom_rug(color = "firebrick", linewidth = 0.8) +
  labs(title = "Muestra simulada (rnorm) sobre la densidad normal teórica",
       x = "x", y = "densidad") +
  theme_minimal()

# pnorm() como área acumulada bajo la curva; qnorm() es la frontera de esa área
ggplot(tibble(x = c(-4, 4)), aes(x)) +
  stat_function(fun = dnorm) +
  stat_function(fun = dnorm, xlim = c(-4, 1.96), geom = "area", fill = "steelblue", alpha = 0.4) +
  geom_vline(xintercept = qnorm(0.975), linetype = "dashed", color = "firebrick") +
  labs(title = "pnorm(1.96): área acumulada a la izquierda de 1.96",
       x = "z", y = "densidad") +
  theme_minimal()

# -----------------------------------------------------------------------------
# 2. Números aleatorios y reproducibilidad
# -----------------------------------------------------------------------------

set.seed(2026)      # fija la semilla: reproducibilidad total de lo aleatorio
rnorm(3)
set.seed(2026)
rnorm(3)             # idéntico al anterior

# -----------------------------------------------------------------------------
# 3. Simulación Monte Carlo
# -----------------------------------------------------------------------------

# Ejemplo 1: Ley de los grandes números
set.seed(1)
lanzamientos <- sample(c(0, 1), size = 10000, replace = TRUE, prob = c(0.5, 0.5))
medias_acumuladas <- cumsum(lanzamientos) / seq_along(lanzamientos)

tibble(n = seq_along(medias_acumuladas), media = medias_acumuladas) %>%
  ggplot(aes(n, media)) +
  geom_line() +
  geom_hline(yintercept = 0.5, color = "red", linetype = "dashed") +
  labs(title = "Ley de los grandes números", x = "n", y = "Proporción acumulada de éxitos") +
  theme_minimal()

# Ejemplo 2: TLC -- muestras de una exponencial (asimétrica), medias se vuelven normales.
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

# ¿Qué pasa cuando n crece? Repetimos la simulación para varios tamaños de muestra.
set.seed(1)
tamanos <- c(1, 2, 5, 10, 30, 100)

medias_por_n <- tibble(
  n     = rep(tamanos, each = n_repeticiones),
  media = unlist(lapply(tamanos, function(k) replicate(n_repeticiones, mean(rexp(k, rate = 1)))))
)

# Escala original: la forma pierde asimetría y se concentra alrededor de la media real (1)
ggplot(medias_por_n, aes(media)) +
  geom_histogram(binwidth = 0.1, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = 1, color = "red", linetype = "dashed") +
  facet_wrap(~ n, labeller = label_both, scales = "free_y") +   # label_both: título "n: 30"
  coord_cartesian(xlim = c(0, 4)) +
  labs(title = "TLC: medias muestrales de Exp(1) al crecer n", x = "media muestral", y = "frecuencia") +
  theme_minimal()

# Estandarizadas, z = (media - mu) / (sigma / sqrt(n)): se acercan a la N(0, 1) (curva roja)
medias_por_n %>%
  mutate(z = (media - 1) / (1 / sqrt(n))) %>%      # Exp(1): mu = 1, sigma = 1
  ggplot(aes(z)) +
  geom_histogram(aes(y = after_stat(density)), bins = 40, fill = "steelblue", alpha = 0.7) +
  stat_function(fun = dnorm, color = "red", linewidth = 1) +
  facet_wrap(~ n, labeller = label_both) +
  coord_cartesian(xlim = c(-3, 5)) +
  labs(title = "TLC: medias estandarizadas vs. normal estándar", x = "z", y = "densidad") +
  theme_minimal()

# Mismo fenómeno con una población discreta: el promedio de n lanzamientos de un dado
set.seed(1)
tamanos_dado <- c(1, 2, 10, 30)

medias_dado <- tibble(
  n     = rep(tamanos_dado, each = n_repeticiones),
  media = unlist(lapply(tamanos_dado, function(k) replicate(n_repeticiones, mean(sample(1:6, k, replace = TRUE)))))
)

ggplot(medias_dado, aes(media)) +
  geom_histogram(binwidth = 0.1, fill = "darkorange", alpha = 0.8) +
  facet_wrap(~ n, labeller = label_both, scales = "free_y") +
  labs(title = "TLC con un dado: promedio de n lanzamientos", x = "promedio de las caras", y = "frecuencia") +
  theme_minimal()

# Otras distribuciones: una función que repite la simulación para cualquier r<dist>()
simular_medias <- function(nombre, rdist, tamanos = c(1, 5, 30, 100)) {
  tibble(
    distribucion = nombre,
    n            = rep(tamanos, each = n_repeticiones),
    media        = unlist(lapply(tamanos, function(k) replicate(n_repeticiones, mean(rdist(k)))))
  )
}

# Continuas: sin importar la forma original, las medias estandarizadas se acercan a la N(0, 1)
set.seed(1)
medias_continuas <- bind_rows(      # bind_rows(): apila tablas con las mismas columnas
  simular_medias("Beta(0.5, 0.5): forma de U",   function(k) rbeta(k, 0.5, 0.5)),
  simular_medias("Chi-cuadrada(1): asimétrica",  function(k) rchisq(k, df = 1)),
  simular_medias("Lognormal(0, 1): cola pesada", function(k) rlnorm(k))
)

medias_continuas %>%
  group_by(distribucion, n) %>%
  mutate(z = (media - mean(media)) / sd(media)) %>%     # estandariza dentro de cada panel
  ggplot(aes(z)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.25, fill = "steelblue", alpha = 0.7) +
  stat_function(fun = dnorm, color = "red", linewidth = 0.8) +
  facet_grid(distribucion ~ n, labeller = labeller(n = label_both)) +
  coord_cartesian(xlim = c(-3, 5)) +
  labs(title = "TLC con distribuciones continuas: medias estandarizadas vs. N(0, 1)", x = "z", y = "densidad") +
  theme_minimal()

# Discretas: se grafica la suma (entera) en vez de la media; tienen la misma forma (media = suma / n)
set.seed(1)
medias_discretas <- bind_rows(
  simular_medias("Poisson(0.5)",    function(k) rpois(k, lambda = 0.5)),
  simular_medias("Geométrica(0.3)", function(k) rgeom(k, prob = 0.3))
)

medias_discretas %>%
  mutate(suma = round(media * n)) %>%
  ggplot(aes(suma)) +
  geom_bar(fill = "darkorange", alpha = 0.8) +
  facet_wrap(~ distribucion + n, scales = "free", ncol = 4, labeller = labeller(n = label_both)) +
  labs(title = "TLC con distribuciones discretas: suma de n observaciones", x = "suma (= n * media)", y = "frecuencia") +
  theme_minimal()

# -----------------------------------------------------------------------------
# 4. Generar datos ficticios para practicar
# -----------------------------------------------------------------------------
# Dataset ficticio combinando sample(), fechas y las funciones r<dist>() ya vistas.

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

# -----------------------------------------------------------------------------
# 5. Estadística descriptiva: resumen numérico
# -----------------------------------------------------------------------------
# Más allá de mean()/sd(), estas son las funciones que vas a usar todo el
# tiempo para resumir una variable numérica.

x <- mtcars$mpg

summary(x)                            # resumen de 6 números: min, Q1, mediana, media, Q3, max
quantile(x)                           # cuartiles (0%, 25%, 50%, 75%, 100%)
quantile(x, probs = c(0.1, 0.9))      # cuantiles arbitrarios
IQR(x)                                # rango intercuartílico: Q3 - Q1 (dispersión robusta)

# cor()/cov(): relación ENTRE dos variables numéricas
cor(mtcars$mpg, mtcars$hp)     # correlación de Pearson, entre -1 y 1
cov(mtcars$mpg, mtcars$hp)     # covarianza (misma idea, sin normalizar a [-1, 1])

# cor() sobre varias columnas a la vez da la matriz de correlaciones
cor(mtcars[, c("mpg", "hp", "wt")])

# skimr::skim() automatiza todo lo anterior: punto de partida típico al explorar un dataset.
skim(mtcars[, c("mpg", "hp", "wt")])

# Lo mismo, con datos reales del curso:
clima <- read_csv("data/clima.csv")
quantile(clima$precipitacion_mm)
IQR(clima$precipitacion_mm)
cor(clima$temperatura_c, clima$precipitacion_mm)

# -----------------------------------------------------------------------------
# 6. Introducción a la inferencia: t.test()
# -----------------------------------------------------------------------------
# t.test() hace una prueba t y, de paso, regresa el intervalo de confianza
# para la media: ya no hace falta calcularlo a mano con error_estandar().

set.seed(2026)
muestra <- rnorm(30, mean = 100, sd = 15)

prueba <- t.test(muestra, mu = 95)   # H0: la media poblacional es 95
prueba
prueba$p.value          # valor p
prueba$conf.int         # intervalo de confianza (95% por default)

# Comparar dos grupos (dos muestras independientes):
grupo1 <- rnorm(20, mean = 50, sd = 5)
grupo2 <- rnorm(20, mean = 53, sd = 5)

t.test(grupo1, grupo2, var.equal = TRUE)    # asumiendo varianzas iguales
t.test(grupo1, grupo2, var.equal = FALSE)   # prueba de Welch (varianzas distintas; es el default)

# Con notación de fórmula, sobre datos reales: ¿difiere la temperatura entre ciudades?
t.test(temperatura_c ~ ciudad, data = clima)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Usando qnorm(), encuentra el valor crítico de una normal estándar para
#    un intervalo de confianza del 90%.

# 2. Simula 10,000 lanzamientos de un dado justo (sample(1:6, ...)) y
#    verifica con una tabla (table()/prop.table()) que cada cara aparece
#    aproximadamente 1/6 de las veces.

# 3. Escribe una función `intervalo_confianza_media(x, conf = 0.95)` que
#    reciba un vector y regrese el intervalo de confianza para la media
#    usando la aproximación normal: media +/- z * error_estandar(x).

# 4. (Reto) Repite la simulación del CLT del ejemplo 2 pero partiendo de una
#    distribución uniforme (runif) y de una binomial con p = 0.05
#    (muy asimétrica). ¿Con qué tamaño de muestra n empieza a verse
#    razonablemente normal en cada caso?

# 5. Genera tu propio dataset ficticio con al menos 4 columnas (incluyendo una
#    fecha y una variable categórica) y n = 150 filas. Usa table()/
#    prop.table() para verificar que las categorías respetan aproximadamente
#    las probabilidades que definiste en el prob de sample().

# 6. Usando mtcars$wt, calcula el resumen de 5 números (quantile()), el IQR,
#    y determina si hay valores atípicos con la regla Q1 - 1.5*IQR /
#    Q3 + 1.5*IQR. ¿Cuál es la correlación entre wt y mpg? ¿Tiene sentido
#    el signo?

# 7. Simula dos muestras normales con medias distintas (rnorm) y usa t.test()
#    para probar si la diferencia de medias es significativa. Repite con
#    medias iguales: ¿cambia el valor p como esperabas?

# =============================================================================
# EJEMPLO: simular y analizar un experimento A/B
# =============================================================================
# Combina simulación, estadística descriptiva y t.test en un solo flujo: el
# tipo de análisis que harías con datos reales de un experimento.

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

# Visualizar antes de probar formalmente -- siempre vale la pena
ggplot(experimento, aes(x = grupo, y = tiempo, fill = grupo)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Tiempo de conversión por grupo del experimento", y = "segundos") +
  theme_minimal()

# t.test() también acepta notación de fórmula (variable ~ grupo):
t.test(tiempo ~ grupo, data = experimento)

# 8. Simula dos muestras normales `grupo_control` y `grupo_tratamiento`
#    (n = 30 cada una) con una diferencia de medias pequeña (p.ej. 50 vs.
#    52) y usa t.test() para ver si la diferencia es significativa. Repite
#    con una diferencia más grande (50 vs. 60): ¿cambia el valor p como
#    esperabas?

# 9. (Reto) Usando tus muestras simuladas del ejercicio 8, repite la
#    simulación 500 veces (con replicate()) y calcula en qué proporción de
#    las repeticiones el t.test() detecta una diferencia significativa
#    (p < 0.05) -- esto es, informalmente, el "poder" de la prueba.

# 10. Usando data/clima.csv, calcula la temperatura promedio y el IQR de
#     precipitación por ciudad (dplyr). ¿La diferencia de temperatura del
#     t.test() de arriba es consistente con esos promedios?

# 11. Repite la visualización de "dónde caen los valores simulados" (sección
#     1) pero para una muestra runif(30, min = 0, max = 10) sobre su
#     densidad teórica (dunif()).
