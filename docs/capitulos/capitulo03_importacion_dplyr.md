# Capítulo 3 — Importación de datos y verbos de dplyr

**Sesión 3 · Día 2, mañana · 2 horas**
Script de práctica: [`sesiones/sesion03_importacion_dplyr.R`](../../sesiones/sesion03_importacion_dplyr.R)

[← Capítulo 2](capitulo02_funciones_apply.md) · [Índice](../../README.md) · [Capítulo 4 →](capitulo04_agregacion_tidyr_ggplot2.md)

## Objetivo

Distinguir `data.frame` de `tibble`, importar datos con readr, y dominar `filter()`/`select()`/`mutate()`/`arrange()` encadenados con el pipe. A partir de aquí el curso se mueve al ecosistema **tidyverse**.

```r
library(tidyverse)
```

## 1. data.frame vs. tibble

`tibble` es la versión moderna de `data.frame` que usa el tidyverse. No cambia tipos por sorpresa, imprime de forma más legible, y es más predecible al indexar.

```r
df_base <- data.frame(x = 1:5, y = letters[1:5])
tbl <- as_tibble(df_base)

class(df_base)
class(tbl)

df_base[, "x"]     # vector
tbl[, "x"]         # tibble (más predecible)
```

Esa última diferencia es sutil pero importante: en un `data.frame`, seleccionar una sola columna con `[,]` puede "caer" a vector; en un `tibble`, siempre obtienes un tibble. Menos sorpresas al escribir funciones genéricas.

## 2. Importar datos con readr

`readr::read_csv()` es más rápido y más predecible que `read.csv()` (base R): no convierte strings a factor por default, e infiere los tipos de columna reportando cómo lo hizo.

```r
# datos <- read_csv("ruta/a/archivo.csv")

# Para la práctica del curso usamos datasets incluidos en R:
datos <- as_tibble(mpg)     # dataset de ggplot2: consumo de autos
datos

glimpse(datos)     # equivalente tidy de str()
```

## 3. El pipe %>%

El pipe encadena operaciones de izquierda a derecha, como el *method chaining* de otros lenguajes: `x %>% f()` es equivalente a `f(x)`.

```r
datos %>% glimpse()
```

> El pipe nativo `|>` (disponible desde R 4.1) es equivalente en casos simples. Usamos `%>%` por su compatibilidad histórica con el ecosistema tidyverse, pero ambos son válidos y puedes usar el que prefieras.

## 4. dplyr: filter, select, mutate, arrange

Estos cuatro verbos cubren la mayoría de la manipulación de datos del día a día.

**`filter()`** selecciona filas por condición:

```r
datos %>% filter(cyl == 4, year == 2008)
```

**`select()`** elige columnas:

```r
datos %>% select(manufacturer, model, cty, hwy)
```

**`mutate()`** crea o modifica columnas:

```r
datos %>%
  mutate(
    eficiencia_prom = (cty + hwy) / 2,
    tipo_motor = if_else(displ > 3, "grande", "chico")
  ) %>%
  select(manufacturer, model, eficiencia_prom, tipo_motor)
```

**`arrange()`** ordena filas:

```r
datos %>% arrange(desc(hwy)) %>% select(manufacturer, model, hwy)
```

Y, como es de esperar, se encadenan con el pipe en un solo flujo legible:

```r
datos %>%
  filter(cyl >= 6) %>%
  select(manufacturer, model, cyl, hwy) %>%
  arrange(desc(hwy))
```

Cada línea del pipeline se lee como un paso independiente — esto hace que el código de dplyr sea, en general, más fácil de leer y depurar que el equivalente en indexación base de R.

## Ejercicios

1. Filtra `mpg` con `cyl == 4` y selecciona solo `manufacturer`, `model`, `cty`, `hwy`.
2. Usa `mutate()` para crear una columna `hwy_km` = `hwy * 1.60934` (millas a kilómetros) y ordénala de mayor a menor.
3. Encadena `filter() %>% select() %>% arrange()` en una sola expresión con el pipe, usando una condición y columnas de tu elección.

---

[← Capítulo 2](capitulo02_funciones_apply.md) · [Índice](../../README.md) · [Capítulo 4 →](capitulo04_agregacion_tidyr_ggplot2.md)
