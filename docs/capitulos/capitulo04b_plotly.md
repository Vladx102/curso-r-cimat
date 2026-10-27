# Capítulo 4b — Gráficos interactivos con plotly

**Sesión 4b · 2 horas**
Script de práctica: [`sesiones/sesion04b_plotly.R`](../../sesiones/sesion04b_plotly.R)

[← Capítulo 4](capitulo04_agregacion_tidyr_ggplot2.md) · [Índice](../../README.md) · [Capítulo 5 →](capitulo05_proyectos_reproducibles.md)

## Objetivo

Construir gráficos interactivos con plotly: primero con `plot_ly()` desde cero (tipos de gráfico, color, etiquetas al pasar el mouse, `layout()`, varias capas y paneles), y después convirtiendo gráficos de ggplot2 con `ggplotly()`.

Un gráfico de plotly permite hacer zoom, ver el valor exacto de cada punto al pasar el mouse y ocultar grupos haciendo clic en la leyenda. Se ve en el panel *Viewer* de RStudio y en documentos HTML (por ejemplo un `.Rmd` con `output: html_document`); en un PDF no se puede mostrar.

```r
library(tidyverse)
library(plotly)       # install.packages("plotly") si no lo tienes

datos <- mpg
```

## 1. Primer gráfico con `plot_ly()`

`plot_ly()` recibe un data frame y las columnas que van en cada eje. A diferencia de ggplot2, las columnas se escriben con `~` adelante: `~displ` significa "la columna `displ` de los datos". El tipo de gráfico se elige con `type` (y, para dispersión y líneas, `mode`).

```r
plot_ly(datos, x = ~displ, y = ~hwy, type = "scatter", mode = "markers")
```

Pasa el mouse sobre los puntos: cada uno muestra sus coordenadas. Arrastra para hacer zoom y da doble clic para regresar a la vista original.

## 2. Tipos de gráfico

**Barras.** A diferencia de `geom_bar()`, plotly no cuenta por ti: se le pasa la tabla ya resumida, con una columna para la categoría y otra para la altura de la barra.

```r
datos %>%
  count(class) %>%
  plot_ly(x = ~class, y = ~n, type = "bar")
```

**Histograma.** Aquí sí basta con la variable; plotly calcula los intervalos.

```r
plot_ly(datos, x = ~hwy, type = "histogram")
```

**Diagrama de caja.** Una caja por cada valor de `x`; al pasar el mouse muestra la mediana, los cuartiles y los extremos.

```r
plot_ly(datos, x = ~class, y = ~hwy, type = "box")
```

**Líneas.** Para series de tiempo se usa `type = "scatter"` con `mode = "lines"`:

```r
clima <- read_csv("data/clima.csv")

clima %>%
  filter(ciudad == "Aguascalientes") %>%
  plot_ly(x = ~fecha, y = ~temperatura_c, type = "scatter", mode = "lines")
```

## 3. Color, forma y etiquetas al pasar el mouse

`color = ~variable` asigna un color por grupo y agrega la leyenda automáticamente. Haz clic en un grupo de la leyenda para ocultarlo y doble clic para dejarlo solo.

```r
plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv,
        type = "scatter", mode = "markers")
```

`symbol` asigna una forma por grupo, y `marker = list(...)` fija propiedades iguales para todos los puntos (tamaño, transparencia):

```r
plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv, symbol = ~drv,
        type = "scatter", mode = "markers",
        marker = list(size = 9, opacity = 0.7))
```

La etiqueta que aparece al pasar el mouse (*tooltip*) se personaliza con `text` y `hoverinfo = "text"`. El texto se arma con `paste0()`, y `<br>` es un salto de línea:

```r
plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv,
        type = "scatter", mode = "markers",
        text = ~paste0(manufacturer, " ", model, "<br>",
                       "Año: ", year, "<br>",
                       "Rendimiento: ", hwy, " mpg"),
        hoverinfo = "text")
```

Esta es la ventaja principal de un gráfico interactivo: puedes identificar qué auto es cada punto sin llenar el gráfico de etiquetas.

## 4. Títulos, ejes y leyenda con `layout()`

`layout()` cumple el papel de `labs()` y `theme()` de ggplot2. Se encadena con `%>%`, y cada eje se configura con una lista: `xaxis = list(title = ..., range = ...)`.

```r
plot_ly(datos, x = ~class, y = ~hwy, color = ~class, type = "box") %>%
  layout(title  = "Rendimiento en carretera por tipo de auto",
         xaxis  = list(title = "Tipo de auto"),
         yaxis  = list(title = "Millas por galón (carretera)", range = c(10, 45)),
         showlegend = FALSE)
```

`showlegend = FALSE` quita la leyenda, que aquí sobra porque el color repite la información del eje x.

## 5. Gráficos con varias capas y varios paneles

**Capas.** Igual que se suman `geom_*()` en ggplot2, en plotly se encadenan `add_markers()`, `add_lines()`, `add_bars()`, etc. Cada capa puede usar sus propios datos. Aquí se combinan los puntos diarios de temperatura con una línea del promedio mensual:

```r
temp_mensual <- clima %>%
  mutate(mes = floor_date(fecha, "month")) %>%
  group_by(ciudad, mes) %>%
  summarize(temp_promedio = mean(temperatura_c), .groups = "drop")

clima %>%
  plot_ly(x = ~fecha, y = ~temperatura_c, color = ~ciudad) %>%
  add_markers(opacity = 0.3) %>%
  add_lines(data = temp_mensual, x = ~mes, y = ~temp_promedio,
            line = list(width = 3)) %>%
  layout(title = "Temperatura diaria y promedio mensual",
         xaxis = list(title = ""),
         yaxis = list(title = "°C"))
```

**Histogramas superpuestos.** Por default plotly pone las barras de cada grupo lado a lado; `barmode = "overlay"` las encima, y `opacity` deja ver las que quedan atrás:

```r
plot_ly(datos, x = ~hwy, color = ~drv, type = "histogram", opacity = 0.6) %>%
  layout(barmode = "overlay",
         title = "Rendimiento en carretera por tracción",
         xaxis = list(title = "hwy"))
```

**Paneles.** `subplot()` pone varios gráficos de plotly lado a lado; `widths` reparte el ancho y `name` define cómo aparece cada uno en la leyenda:

```r
g_hist <- plot_ly(datos, x = ~hwy, type = "histogram", name = "histograma")
g_caja <- plot_ly(datos, y = ~hwy, type = "box", name = "caja")

subplot(g_hist, g_caja, widths = c(0.7, 0.3)) %>%
  layout(title = "Dos vistas de la misma variable")
```

## 6. Combinar con ggplot2: `ggplotly()`

No hace falta aprender plotly desde cero para tener gráficos interactivos: `ggplotly()` toma un gráfico de ggplot2 y lo convierte. Es la forma más rápida cuando ya sabes construir el gráfico con ggplot2.

```r
g <- ggplot(datos, aes(displ, hwy, color = drv)) +
  geom_point() +
  labs(title = "Cilindrada vs. rendimiento", x = "displ (litros)", y = "hwy (mpg)") +
  theme_minimal()

ggplotly(g)
```

Para controlar la etiqueta del mouse se agrega una estética `text` en `aes()` (ggplot2 la ignora al dibujar) y se le dice a `ggplotly()` que use solo esa con `tooltip = "text"`:

```r
g_etiquetas <- ggplot(datos, aes(displ, hwy, color = drv,
                                 text = paste0(manufacturer, " ", model,
                                               "<br>hwy: ", hwy))) +
  geom_point() +
  theme_minimal()

ggplotly(g_etiquetas, tooltip = "text")
```

Las facetas y los geoms de resumen como `geom_smooth()` también se convierten:

```r
g_facetas <- ggplot(datos, aes(displ, hwy)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  facet_wrap(~ drv) +
  theme_minimal()

ggplotly(g_facetas)
```

El resultado de `ggplotly()` es un gráfico de plotly como cualquier otro, así que se le puede seguir aplicando `layout()`:

```r
ggplotly(g) %>%
  layout(legend = list(orientation = "h", y = -0.2))   # leyenda horizontal abajo
```

**¿Cuándo usar cada uno?** `ggplotly()` es lo más práctico si ya tienes el gráfico en ggplot2 o necesitas facetas. `plot_ly()` da más control sobre la interacción (etiquetas, capas con datos distintos, `subplot()`) y algunos tipos de gráfico solo existen en plotly.

## Ejercicios

1. Con `iris`, haz con `plot_ly()` un gráfico de dispersión de `Sepal.Length` (x) contra `Petal.Length` (y), coloreado por `Species`.
2. Importa [`data/libros.csv`](../../data/libros.csv) y haz con `plot_ly()` un gráfico de barras del número de libros por `genero`.
3. Importa [`data/empleados.csv`](../../data/empleados.csv) y haz con `plot_ly()` un diagrama de caja del `salario` por `departamento`. Ponle título y nombres a los ejes con `layout()`, y oculta la leyenda.
4. Con `mtcars`, haz un gráfico de dispersión de `wt` contra `mpg` con `plot_ly()` donde, al pasar el mouse, aparezca el nombre del auto (`rownames(mtcars)`) y su `mpg` en dos líneas.
5. Con `iris`, superpón en un solo gráfico los histogramas de `Petal.Width` de las tres especies (un color por especie, con transparencia).
6. Con `iris`, construye con ggplot2 un boxplot de `Sepal.Width` por `Species` con los puntos encima (`geom_jitter()`) y conviértelo con `ggplotly()`.
7. **Reto:** con `empleados.csv`, pon lado a lado con `subplot()` un histograma del `salario` y un gráfico de dispersión de `antiguedad_anios` contra `salario`, con un título general.

---

[← Capítulo 4](capitulo04_agregacion_tidyr_ggplot2.md) · [Índice](../../README.md) · [Capítulo 5 →](capitulo05_proyectos_reproducibles.md)
