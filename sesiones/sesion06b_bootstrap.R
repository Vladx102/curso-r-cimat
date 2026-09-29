# =============================================================================
# Sesión 6b — Bootstrap
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Entender el bootstrap como técnica de remuestreo para aproximar la
#   distribución muestral de un estadístico sin depender de supuestos
#   paramétricos, construir intervalos de confianza bootstrap (método
#   percentil), y aplicarlo a estadísticos sin fórmula cerrada simple
#   (mediana, correlación, diferencia de medias).

library(tidyverse)

# -----------------------------------------------------------------------------
# 1. ¿Qué es bootstrap? Remuestreo con reemplazo
# -----------------------------------------------------------------------------
# Tratamos la muestra que ya tenemos como si fuera la población, y sacamos
# remuestras del mismo tamaño, CON reemplazo.

set.seed(2026)
x <- mtcars$mpg

remuestra <- sample(x, size = length(x), replace = TRUE)
remuestra   # algunos valores se repiten, otros quedan fuera -- así es el chiste

# -----------------------------------------------------------------------------
# 2. Bootstrap manual con replicate()
# -----------------------------------------------------------------------------

set.seed(2026)
B <- 2000   # número de remuestras
medias_boot <- replicate(B, mean(sample(x, replace = TRUE)))

hist(medias_boot, breaks = 40, col = "steelblue", main = "Distribución bootstrap de la media")
mean(medias_boot)   # se acerca a mean(x)
sd(medias_boot)      # "error estándar bootstrap"

# -----------------------------------------------------------------------------
# 3. Intervalo de confianza bootstrap (método percentil)
# -----------------------------------------------------------------------------

quantile(medias_boot, probs = c(0.025, 0.975))

# Comparar contra el intervalo clásico (asume normalidad):
t.test(x)$conf.int

# -----------------------------------------------------------------------------
# 4. Bootstrap para otros estadísticos: mediana
# -----------------------------------------------------------------------------
# No hay una fórmula cerrada simple para el error estándar de la mediana --
# el bootstrap no necesita una.

set.seed(2026)
medianas_boot <- replicate(B, median(sample(x, replace = TRUE)))
quantile(medianas_boot, probs = c(0.025, 0.975))

# -----------------------------------------------------------------------------
# 5. Bootstrap "por filas": estadísticos entre dos variables
# -----------------------------------------------------------------------------
# Para algo como la correlación, no puedes remuestrear cada vector por
# separado -- rompería la relación entre las variables. Remuestreas FILAS.

n <- nrow(mtcars)
set.seed(2026)
cors_boot <- replicate(B, {
  filas <- sample(1:n, size = n, replace = TRUE)
  muestra <- mtcars[filas, ]
  cor(muestra$mpg, muestra$hp)
})

quantile(cors_boot, probs = c(0.025, 0.975))
cor(mtcars$mpg, mtcars$hp)   # el valor observado, para comparar

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Calcula un intervalo de confianza bootstrap (percentil, B = 2000) para
#    la desviación estándar de mtcars$hp.

# 2. Calcula un intervalo de confianza bootstrap para la correlación entre
#    wt y mpg en mtcars (remuestreando filas, como en la sección 5).

# 3. Importa data/clima.csv y compara el intervalo de confianza bootstrap
#    para la media de precipitacion_mm contra el de t.test(). ¿Son
#    parecidos? (Pista: precipitación suele ser una variable asimétrica.)

# 4. (Reto) Simula dos muestras normales grupo1 y grupo2 (como en la sesión
#    6) y calcula un intervalo de confianza bootstrap para la diferencia de
#    medias (mean(grupo1) - mean(grupo2)), remuestreando cada grupo por
#    separado dentro de un solo replicate(). Compáralo con el intervalo de
#    t.test(grupo1, grupo2).

# =============================================================================
# EJEMPLO: bootstrap sobre datos reales -- diferencia de temperatura
# =============================================================================
# Cierra el círculo con el t.test(temperatura_c ~ ciudad) de la sesión 6,
# pero ahora con un intervalo de confianza bootstrap.

clima <- read_csv("data/clima.csv")

diferencia_temp <- function(datos) {
  medias <- tapply(datos$temperatura_c, datos$ciudad, mean)
  medias[1] - medias[2]
}

diferencia_temp(clima)   # diferencia observada, sin remuestrear

n_clima <- nrow(clima)
set.seed(2026)
dif_boot <- replicate(B, {
  filas <- sample(1:n_clima, size = n_clima, replace = TRUE)
  diferencia_temp(clima[filas, ])
})

quantile(dif_boot, probs = c(0.025, 0.975))

# Comparar contra el intervalo de confianza clásico de la sesión 6:
t.test(temperatura_c ~ ciudad, data = clima)$conf.int

# 5. Usando el mismo patrón de "remuestrear filas + función propia", calcula
#    un intervalo de confianza bootstrap para la diferencia de precipitación
#    promedio entre las dos ciudades de clima.csv.

# 6. (Reto) Escribe una función bootstrap_ic(x, FUN, B = 2000, conf = 0.95)
#    que reciba un vector, una función (mean, median, sd...) y regrese el
#    intervalo de confianza bootstrap para ese estadístico. Pruébala con
#    al menos dos funciones distintas sobre mtcars$qsec.
