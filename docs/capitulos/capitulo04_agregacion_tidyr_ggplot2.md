# Capítulo 4 — Agregación, tidyr y ggplot2

**Sesión 4 · Día 2, tarde · 2 horas**
Script de práctica: [`sesiones/sesion04_agregacion_tidyr_ggplot2.R`](../../sesiones/sesion04_agregacion_tidyr_ggplot2.R)

[← Capítulo 3](capitulo03_importacion_dplyr.md) · [Índice](../../README.md) · [Capítulo 5 →](capitulo05_proyectos_reproducibles.md)

## Objetivo

Agregar datos por grupo con `group_by()` + `summarize()`, reformar tablas con tidyr, y construir las primeras visualizaciones con ggplot2.

```r
library(tidyverse)
datos <- as_tibble(mpg)
```

## 1. group_by() + summarize()

Este es el equivalente en R de un `GROUP BY` de SQL o un `groupby().agg()` de pandas: agrupas filas por una o más columnas y luego resumes cada grupo con una función de agregación.

```r
datos %>%
  group_by(class) %>%
  summarize(
    n = n(),
    hwy_prom = mean(hwy),
    hwy_sd = sd(hwy)
  ) %>%
  arrange(desc(hwy_prom))
```

Como todo en dplyr, se combina naturalmente con los verbos del capítulo anterior:

```r
resumen_fabricante <- datos %>%
  filter(cyl >= 6) %>%
  group_by(manufacturer) %>%
  summarize(hwy_prom = mean(hwy), .groups = "drop") %>%
  arrange(desc(hwy_prom))
resumen_fabricante
```

## 2. tidyr: reformar datos y joins

tidyr resuelve un problema muy común: pasar de formato ancho a largo (o viceversa) y combinar tablas.

`pivot_longer()` convierte columnas en filas:

```r
ancho <- tibble(
  pais = c("MX", "US", "CA"),
  y2020 = c(10, 20, 15),
  y2021 = c(12, 22, 14)
)

largo <- ancho %>%
  pivot_longer(cols = starts_with("y"), names_to = "anio", values_to = "valor")
largo
```

`pivot_wider()` hace lo inverso:

```r
largo %>% pivot_wider(names_from = anio, values_from = valor)
```

Y los *joins* funcionan igual que en SQL:

```r
poblacion <- tibble(pais = c("MX", "US", "CA"), poblacion_m = c(128, 331, 38))
largo %>% left_join(poblacion, by = "pais")
```

## 3. ggplot2: gramática de gráficos

ggplot2 construye gráficos por capas: empiezas con los datos y un mapeo estético (`aes()`), y vas sumando geometrías (`geom_*()`) y ajustes.

```r
ggplot(datos, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Rendimiento en carretera vs. desplazamiento del motor",
    x = "Desplazamiento (L)", y = "Millas por galón (carretera)",
    color = "Clase"
  ) +
  theme_minimal()
```

**Facetas**, un panel por categoría:

```r
ggplot(datos, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~ class) +
  theme_minimal()
```

**Distribuciones**, con histograma o boxplot:

```r
ggplot(datos, aes(x = hwy)) +
  geom_histogram(binwidth = 2, fill = "steelblue", color = "white")

ggplot(datos, aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()
```

La ventaja de este enfoque por capas es que puedes construir gráficos complejos sumando piezas simples, sin tener que aprender una función distinta para cada tipo de visualización.

## Ejercicios

1. Con `mpg`, filtra `drv == "4"` y calcula el promedio de `hwy` por `manufacturer`, ordenado de mayor a menor.
2. Crea una columna nueva `eficiente` (`TRUE` si `hwy > 30`) y grafica un boxplot de `displ` separado por esa nueva variable.
3. Usa `pivot_wider()` sobre `datos %>% count(class, drv)` para obtener una tabla con clases como filas y tipos de tracción (`drv`) como columnas.
4. **Reto:** reproduce con ggplot2 un gráfico de dispersión de `cty` vs. `hwy`, coloreado por `class`, con una línea de tendencia por clase (`geom_smooth(method = "lm")` dentro de `aes(color = class)`).

---

[← Capítulo 3](capitulo03_importacion_dplyr.md) · [Índice](../../README.md) · [Capítulo 5 →](capitulo05_proyectos_reproducibles.md)
