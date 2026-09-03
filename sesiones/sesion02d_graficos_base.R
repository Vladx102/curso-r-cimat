# =============================================================================
# Sesión 2d — Gráficos con R base
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Graficar con las funciones de base R (plot, barplot, hist, boxplot)
#   antes de llegar a ggplot2 en la sesión 4 — útil para exploración
#   rápida y para entender qué automatiza ggplot2 después.

# mtcars: datos de Motor Trend (1974), un auto por fila
# mpg   - millas por galón (rendimiento)
# cyl   - número de cilindros
# disp  - desplazamiento del motor (pulgadas cúbicas)
# hp    - caballos de fuerza
# drat  - relación de transmisión del eje trasero
# wt    - peso (miles de libras)
# qsec  - tiempo en 1/4 de milla (segundos)
# vs    - forma del motor (0 = V, 1 = en línea)
# am    - transmisión (0 = automática, 1 = manual)
# gear  - número de marchas
# carb  - número de carburadores

# -----------------------------------------------------------------------------
# 1. plot(): dispersión de puntos
# -----------------------------------------------------------------------------
# type = "p"  puntos (default)
# type = "l"  línea
# type = "b"  puntos y línea, con espacio alrededor del punto ("both")
# type = "c"  como "b" pero sin los puntos, solo el hueco
# type = "o"  puntos y línea superpuestos, sin espacio ("overplotted")
# type = "h"  líneas verticales desde el eje x a cada punto (tipo histograma)
# type = "s"  escalón: sube/baja después de cada punto
# type = "S"  escalón: sube/baja antes de cada punto
# type = "n"  no dibuja nada, solo prepara ejes/marco


# wt    - peso (miles de libras)
# mpg   - millas por galón (rendimiento)


plot(mtcars$wt, mtcars$mpg)

plot(mtcars$wt, mtcars$mpg,
  main = "Peso vs. rendimiento",
  xlab = "Peso (miles de lb)", ylab = "Millas por galón",
  pch = 19, col = "steelblue"
)


plot
# -----------------------------------------------------------------------------
# 2. plot(): líneas
# -----------------------------------------------------------------------------

ventas_mensuales <- c(120, 135, 128, 150, 145, 160, 158, 170, 165, 180, 190, 200)
meses <- 1:12

plot(meses, ventas_mensuales, type = "l")

plot(meses, ventas_mensuales,
  type = "o", col = "darkgreen", pch = 16,
  main = "Ventas mensuales", xlab = "Mes", ylab = "Ventas (miles)"
)

# -----------------------------------------------------------------------------
# 3. barplot(): barras
# -----------------------------------------------------------------------------

# cyl   - número de cilindros

conteo_cyl <- table(mtcars$cyl)
conteo_cyl

barplot(conteo_cyl,
  main = "Autos por número de cilindros",
  xlab = "Cilindros", ylab = "Cantidad", col = "coral"
)

# -----------------------------------------------------------------------------
# 4. hist(): distribución
# -----------------------------------------------------------------------------

hist(mtcars$mpg)

hist(mtcars$mpg,
  breaks = 10, col = "lightblue",
  main = "Distribución de millas por galón", xlab = "mpg"
)

# -----------------------------------------------------------------------------
# 5. boxplot(): cajas
# -----------------------------------------------------------------------------

# mpg   - millas por galón (rendimiento)

boxplot(mtcars$mpg)

# Interfaz de fórmula y ~ x: la misma sintaxis que usarás con lm() más adelante
boxplot(mpg ~ cyl,
  data = mtcars,
  main = "mpg por número de cilindros",
  xlab = "Cilindros", ylab = "mpg", col = "lightyellow"
)

# -----------------------------------------------------------------------------
# 6. Paneles múltiples y personalización
# -----------------------------------------------------------------------------

par(mfrow = c(1, 2))
hist(mtcars$mpg, col = "lightblue", main = "Histograma")
boxplot(mtcars$mpg, col = "lightyellow", main = "Boxplot")


# =============================================================================
# EJERCICIO
# =============================================================================

# Usando el dataset incluido `mtcars`:
#   a) haz un boxplot de hp separado por "am" (0 = automático, 1 = manual)
#   b) haz un barplot con el conteo de autos por número de marchas (gear)
#   c) haz un histograma de "disp" con 15 breaks

# =============================================================================
# EJEMPLO: temperatura diaria de una ciudad
# =============================================================================

dias <- 1:30
temperatura <- c(
  18, 19, 17, 20, 22, 21, 19, 18, 20, 23,
  24, 22, 21, 19, 18, 17, 19, 21, 23, 25,
  26, 24, 22, 20, 19, 18, 20, 22, 24, 23
)

plot(dias, temperatura,
  type = "l", col = "firebrick",
  main = "Temperatura diaria", xlab = "Día", ylab = "°C"
)

hist(temperatura, col = "lightblue", main = "Distribución de temperaturas")

categoria <- ifelse(temperatura < 20, "fría", ifelse(temperatura < 24, "templada", "cálida"))
conteo_categoria <- table(categoria)

barplot(conteo_categoria,
  main = "Días por categoría de temperatura",
  col = c("tomato", "gold", "skyblue")
)

boxplot(temperatura ~ categoria,
  main = "Temperatura por categoría",
  xlab = "Categoría", ylab = "°C", col = "lightgreen"
)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 2. Crea un vector `precipitacion` de 30 valores (inventa datos razonables
#    en mm) y grafica su serie de tiempo con plot(type = "l").

# 3. (Reto) Usando `dias`, `temperatura` y `precipitacion`, usa
#    par(mfrow = c(1, 2)) para mostrar ambas series de tiempo lado a lado
#    en la misma ventana gráfica.
