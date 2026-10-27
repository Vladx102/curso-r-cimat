# =============================================================================
# Sesión 4b — Gráficos interactivos con plotly
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Construir gráficos interactivos con plotly: primero con plot_ly() desde
#   cero (tipos de gráfico, color, etiquetas al pasar el mouse, layout(),
#   varias capas y paneles), y después convirtiendo gráficos de ggplot2 con
#   ggplotly().
#
# Las gráficas de plotly se ven en el panel Viewer de RStudio y en documentos
# HTML; en un PDF no se pueden mostrar.

library(tidyverse)
library(plotly)       # install.packages("plotly") si no lo tienes

datos <- mpg

# -----------------------------------------------------------------------------
# 1. Primer gráfico con plot_ly()
# -----------------------------------------------------------------------------
# Las columnas se indican con ~ (fórmula): ~displ significa "la columna displ".

plot_ly(datos, x = ~displ, y = ~hwy, type = "scatter", mode = "markers")

# -----------------------------------------------------------------------------
# 2. Tipos de gráfico
# -----------------------------------------------------------------------------

# Barras: plotly no cuenta solo, se le pasan los conteos ya calculados
datos %>%
  count(class) %>%
  plot_ly(x = ~class, y = ~n, type = "bar")

# Histograma: aquí sí cuenta plotly
plot_ly(datos, x = ~hwy, type = "histogram")

# Cajas: una por categoría
plot_ly(datos, x = ~class, y = ~hwy, type = "box")

# Líneas: series de tiempo
clima <- read_csv("data/clima.csv")

clima %>%
  filter(ciudad == "Aguascalientes") %>%
  plot_ly(x = ~fecha, y = ~temperatura_c, type = "scatter", mode = "lines")

# -----------------------------------------------------------------------------
# 3. Color, tamaño y etiquetas al pasar el mouse
# -----------------------------------------------------------------------------

plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv,
        type = "scatter", mode = "markers")

# symbol: una forma por grupo; marker = list(...) fija propiedades para todos los puntos
plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv, symbol = ~drv,
        type = "scatter", mode = "markers",
        marker = list(size = 9, opacity = 0.7))

# text + hoverinfo = "text": tú decides qué aparece al pasar el mouse
plot_ly(datos, x = ~displ, y = ~hwy, color = ~drv,
        type = "scatter", mode = "markers",
        text = ~paste0(manufacturer, " ", model, "<br>",   # <br> = salto de línea
                       "Año: ", year, "<br>",
                       "Rendimiento: ", hwy, " mpg"),
        hoverinfo = "text")

# -----------------------------------------------------------------------------
# 4. Títulos, ejes y leyenda con layout()
# -----------------------------------------------------------------------------
# layout() es el equivalente de labs()/theme() de ggplot2; se encadena con %>%.

plot_ly(datos, x = ~class, y = ~hwy, color = ~class, type = "box") %>%
  layout(title  = "Rendimiento en carretera por tipo de auto",
         xaxis  = list(title = "Tipo de auto"),
         yaxis  = list(title = "Millas por galón (carretera)", range = c(10, 45)),
         showlegend = FALSE)

# -----------------------------------------------------------------------------
# 5. Gráficos con varias capas y varios paneles
# -----------------------------------------------------------------------------

# Capas: add_markers(), add_lines(), add_bars() agregan trazos al mismo gráfico
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

# Histogramas superpuestos: barmode = "overlay" + opacity
plot_ly(datos, x = ~hwy, color = ~drv, type = "histogram", opacity = 0.6) %>%
  layout(barmode = "overlay",
         title = "Rendimiento en carretera por tracción",
         xaxis = list(title = "hwy"))

# subplot(): varios gráficos lado a lado
g_hist <- plot_ly(datos, x = ~hwy, type = "histogram", name = "histograma")
g_caja <- plot_ly(datos, y = ~hwy, type = "box", name = "caja")

subplot(g_hist, g_caja, widths = c(0.7, 0.3)) %>%
  layout(title = "Dos vistas de la misma variable")

# -----------------------------------------------------------------------------
# 6. Combinar con ggplot2: ggplotly()
# -----------------------------------------------------------------------------
# Construyes el gráfico con ggplot2 (lo que ya sabes) y ggplotly() lo vuelve
# interactivo: zoom, etiquetas al pasar el mouse, ocultar grupos en la leyenda.

g <- ggplot(datos, aes(displ, hwy, color = drv)) +
  geom_point() +
  labs(title = "Cilindrada vs. rendimiento", x = "displ (litros)", y = "hwy (mpg)") +
  theme_minimal()

ggplotly(g)

# Etiquetas propias: aes(text = ...) + tooltip = "text"
g_etiquetas <- ggplot(datos, aes(displ, hwy, color = drv,
                                 text = paste0(manufacturer, " ", model,
                                               "<br>hwy: ", hwy))) +
  geom_point() +
  theme_minimal()

ggplotly(g_etiquetas, tooltip = "text")

# Las facetas y los geoms de resumen también se convierten
g_facetas <- ggplot(datos, aes(displ, hwy)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "loess", se = FALSE) +
  facet_wrap(~ drv) +
  theme_minimal()

ggplotly(g_facetas)

# Al resultado de ggplotly() se le puede seguir aplicando layout()
ggplotly(g) %>%
  layout(legend = list(orientation = "h", y = -0.2))   # leyenda horizontal abajo

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Con iris, haz con plot_ly() un gráfico de dispersión de Sepal.Length
#    (x) contra Petal.Length (y), coloreado por Species.

# 2. Importa data/libros.csv y haz con plot_ly() un gráfico de barras del
#    número de libros por genero.

# 3. Importa data/empleados.csv y haz con plot_ly() un diagrama de caja del
#    salario por departamento. Ponle título y nombres a los ejes con
#    layout(), y oculta la leyenda.

# 4. Con mtcars, haz un gráfico de dispersión de wt contra mpg con plot_ly()
#    donde, al pasar el mouse, aparezca el nombre del auto (rownames(mtcars))
#    y su mpg en dos líneas.

# 5. Con iris, superpón en un solo gráfico los histogramas de Petal.Width
#    de las tres especies (un color por especie, con transparencia).

# 6. Con iris, construye con ggplot2 un boxplot de Sepal.Width por Species
#    con los puntos encima (geom_jitter()) y conviértelo con ggplotly().

# 7. (Reto) Con empleados.csv, pon lado a lado con subplot() un histograma
#    del salario y un gráfico de dispersión de antiguedad_anios contra
#    salario, con un título general.
