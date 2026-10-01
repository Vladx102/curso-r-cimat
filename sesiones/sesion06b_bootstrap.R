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
# EJEMPLOS
# =============================================================================

# Ejemplo 1: diferencia de temperatura entre ciudades (datos reales)
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

# Ejemplo 2: ver la distribución bootstrap -- mediana del monto de venta
ventas <- read_csv("data/ventas.csv")

set.seed(2026)
medianas_monto <- replicate(B, median(sample(ventas$monto, replace = TRUE)))
ic_mediana <- quantile(medianas_monto, probs = c(0.025, 0.975))
ic_mediana

tibble(mediana = medianas_monto) %>%
  ggplot(aes(mediana)) +
  geom_histogram(bins = 40, fill = "steelblue", alpha = 0.7) +
  geom_vline(xintercept = median(ventas$monto), color = "red") +            # mediana observada
  geom_vline(xintercept = ic_mediana, color = "red", linetype = "dashed") + # límites del IC
  labs(title = "Distribución bootstrap de la mediana del monto",
       x = "mediana de la remuestra", y = "frecuencia") +
  theme_minimal()

# Ejemplo 3: una proporción -- préstamos sin devolver
# Una proporción es la media de un vector lógico: mismo procedimiento.
prestamos <- read_csv("data/prestamos.csv")

sin_devolver <- is.na(prestamos$fecha_devolucion)   # TRUE/FALSE por préstamo
mean(sin_devolver)                                  # proporción observada

set.seed(2026)
prop_boot <- replicate(B, mean(sample(sin_devolver, replace = TRUE)))
quantile(prop_boot, probs = c(0.025, 0.975))

# Ejemplo 4: estadístico propio con muestra chica (n = 25) -- coeficiente de variación
empleados <- read_csv("data/empleados.csv")

coef_variacion <- function(v) sd(v) / mean(v)
coef_variacion(empleados$salario)

set.seed(2026)
cv_boot <- replicate(B, coef_variacion(sample(empleados$salario, replace = TRUE)))
quantile(cv_boot, probs = c(0.025, 0.975))

# Ejemplo 5: ¿cuántas remuestras B? El IC se estabiliza al crecer B
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

# 5. Usando el mismo patrón de "remuestrear filas + función propia", calcula
#    un intervalo de confianza bootstrap para la diferencia de precipitación
#    promedio entre las dos ciudades de clima.csv.

# 6. (Reto) Escribe una función bootstrap_ic(x, FUN, B = 2000, conf = 0.95)
#    que reciba un vector, una función (mean, median, sd...) y regrese el
#    intervalo de confianza bootstrap para ese estadístico. Pruébala con
#    al menos dos funciones distintas sobre mtcars$qsec.

# 7. Los tiempos de espera (en minutos) de 20 clientes en una ventanilla:
#      espera <- c(3, 5, 4, 7, 2, 6, 4, 5, 3, 8, 4, 6, 5, 3, 7, 4, 5, 42, 6, 4)
#    Calcula un intervalo de confianza bootstrap para la media y otro para
#    la mediana. ¿Cuál es más ancho? ¿Qué valor de los datos lo explica?

# 8. Con setosa <- iris$Sepal.Length[iris$Species == "setosa"], calcula un
#    intervalo de confianza bootstrap para la mediana y grafica el
#    histograma de la distribución bootstrap, marcando con líneas verticales
#    la mediana observada y los dos límites del intervalo.

# 9. En mtcars, am == 1 indica transmisión manual. Calcula un intervalo de
#    confianza bootstrap para la proporción de autos manuales.

# 10. Importa data/libros.csv y calcula un intervalo de confianza bootstrap
#     para el percentil 90 de num_paginas (quantile(v, 0.9)).

# 11. Corre estas líneas para que todos tengan los mismos datos:
#       set.seed(10)
#       muestra_chica  <- rexp(15,  rate = 1 / 20)
#       muestra_grande <- rexp(150, rate = 1 / 20)
#     Calcula el intervalo de confianza bootstrap para la media de cada una
#     y compara sus anchos con diff(). ¿Qué pasa al tener más datos?

# 12. (Reto) Calcula la distribución bootstrap del máximo de mtcars$mpg y
#     revísala con table(). ¿Por qué toma tan pocos valores distintos? ¿Es
#     confiable un intervalo de confianza construido así?
