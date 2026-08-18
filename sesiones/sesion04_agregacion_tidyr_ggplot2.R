# =============================================================================
# Sesión 4 — Día 2 · tarde — Agregación, tidyr y ggplot2
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Agregar datos con group_by()+summarize(), reformar tablas con tidyr y
#   construir las primeras visualizaciones con ggplot2.

library(tidyverse)
datos <- as_tibble(mpg)

# -----------------------------------------------------------------------------
# 1. group_by() + summarize(): el equivalente de un group-by/aggregate
# -----------------------------------------------------------------------------

datos %>%
  group_by(class) %>%
  summarize(
    n = n(),
    hwy_prom = mean(hwy),
    hwy_sd = sd(hwy)
  ) %>%
  arrange(desc(hwy_prom))

# Todo se encadena con el pipe %>%
resumen_fabricante <- datos %>%
  filter(cyl >= 6) %>%
  group_by(manufacturer) %>%
  summarize(hwy_prom = mean(hwy), .groups = "drop") %>%
  arrange(desc(hwy_prom))
resumen_fabricante

# -----------------------------------------------------------------------------
# 2. tidyr: reformar datos (long <-> wide) y joins
# -----------------------------------------------------------------------------

ancho <- tibble(
  pais = c("MX", "US", "CA"),
  y2020 = c(10, 20, 15),
  y2021 = c(12, 22, 14)
)

largo <- ancho %>%
  pivot_longer(cols = starts_with("y"), names_to = "anio", values_to = "valor")
largo

largo %>% pivot_wider(names_from = anio, values_from = valor)

# joins: igual que en SQL
poblacion <- tibble(pais = c("MX", "US", "CA"), poblacion_m = c(128, 331, 38))
largo %>% left_join(poblacion, by = "pais")

# -----------------------------------------------------------------------------
# 3. ggplot2: gramática de gráficos
# -----------------------------------------------------------------------------
# Estructura: ggplot(data, aes(x, y, ...)) + geom_*() + ajustes

ggplot(datos, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Rendimiento en carretera vs. desplazamiento del motor",
    x = "Desplazamiento (L)", y = "Millas por galón (carretera)",
    color = "Clase"
  ) +
  theme_minimal()

# Facetas: un panel por categoría
ggplot(datos, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~ class) +
  theme_minimal()

# Distribuciones
ggplot(datos, aes(x = hwy)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "white")

ggplot(datos, aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Con `mpg`, filtra drv == "4" y calcula el promedio de hwy por
#    manufacturer, ordenado de mayor a menor.

# 2. Crea una columna nueva `eficiente` (TRUE si hwy > 30) y grafica un
#    boxplot de displ separado por esa nueva variable.

# 3. Usa pivot_wider() sobre `datos %>% count(class, drv)` para obtener una
#    tabla con clases como filas y tipos de tracción (drv) como columnas.

# 4. (Reto) Reproduce con ggplot2 un gráfico de dispersión de cty vs hwy,
#    coloreado por class, con una línea de tendencia por clase
#    (geom_smooth(method = "lm") dentro de aes(color = class)).
