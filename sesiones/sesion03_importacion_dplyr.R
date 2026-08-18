# =============================================================================
# Sesión 3 — Día 2 · mañana — Importación de datos y verbos de dplyr
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Distinguir data.frame de tibble, importar datos con readr/readxl, dominar
#   filter/select/mutate/arrange encadenados con el pipe, manejar cadenas de
#   texto con stringr, y fechas con lubridate.

# install.packages("tidyverse")   # ejecutar una sola vez si falta
library(tidyverse)
library(readxl)     # importar Excel (.xlsx); no es parte del "core" tidyverse,
                     # pero se instala junto con install.packages("tidyverse")
library(lubridate)  # manejo de fechas; ya viene cargado con library(tidyverse),
                     # pero lo cargamos explícito para dejar claro de dónde sale

# -----------------------------------------------------------------------------
# 1. data.frame vs. tibble
# -----------------------------------------------------------------------------

df_base <- data.frame(x = 1:5, y = letters[1:5])
tbl <- as_tibble(df_base)

class(df_base)
class(tbl)

# Diferencias prácticas: tibble no cambia tipos por sorpresa, imprime bonito,
# y df[, "col"] en data.frame puede "caer" a vector; en tibble siempre da tibble.
df_base[, "x"]     # vector
tbl[, "x"]         # tibble (más predecible)

# -----------------------------------------------------------------------------
# 2. Importar datos con readr
# -----------------------------------------------------------------------------
# readr::read_csv() es más rápido y predecible que read.csv() base:
#   - no convierte strings a factor por default
#   - infiere tipos de columna e informa cómo lo hizo

# datos <- read_csv("ruta/a/archivo.csv")
# Para esta práctica usamos datasets incluidos en R:
datos <- as_tibble(mpg)     # dataset de ggplot2: consumo de autos
datos

glimpse(datos)     # equivalente tidy de str()

# readxl::read_excel() lee archivos .xlsx/.xls -- muy común cuando los datos
# vienen de alguien que trabaja en Excel. No tiene "write_excel()"; para
# exportar a Excel se usa el paquete openxlsx (fuera del alcance de este curso).
# datos_excel <- read_excel("ruta/a/archivo.xlsx", sheet = "Hoja1")

# -----------------------------------------------------------------------------
# 3. El pipe %>%
# -----------------------------------------------------------------------------
# El pipe encadena operaciones de izquierda a derecha, como method chaining:
# x %>% f() es equivalente a f(x). El pipe nativo |> es similar en casos
# simples; usaremos %>% por compatibilidad con el ecosistema tidyverse.

datos %>% glimpse()

# -----------------------------------------------------------------------------
# 4. dplyr: filter, select, mutate, arrange
# -----------------------------------------------------------------------------

# filter(): seleccionar filas por condición
datos %>% filter(cyl == 4, year == 2008)

# select(): elegir columnas
datos %>% select(manufacturer, model, cty, hwy)

# mutate(): crear/modificar columnas
datos %>%
  mutate(
    eficiencia_prom = (cty + hwy) / 2,
    tipo_motor = if_else(displ > 3, "grande", "chico")
  ) %>%
  select(manufacturer, model, eficiencia_prom, tipo_motor)

# arrange(): ordenar
datos %>% arrange(desc(hwy)) %>% select(manufacturer, model, hwy)

# Encadenando varios verbos:
datos %>%
  filter(cyl >= 6) %>%
  select(manufacturer, model, cyl, hwy) %>%
  arrange(desc(hwy))

# -----------------------------------------------------------------------------
# 5. Manejo de cadenas con stringr
# -----------------------------------------------------------------------------
# stringr (parte del tidyverse) da funciones consistentes para texto: todas
# empiezan con str_ y reciben primero el vector de texto, como el resto del
# tidyverse. Base R tiene equivalentes (paste, substr, toupper, gsub...),
# pero stringr es más predecible y legible.

nombres <- c("  Ana García", "luis PEREZ", "Marta lopez ")

str_trim(nombres)                  # quita espacios al inicio/final
str_to_lower(nombres)              # minúsculas
str_to_upper(nombres)              # MAYÚSCULAS
str_to_title(str_trim(nombres))    # Formato Título

str_length(nombres)                # número de caracteres
str_detect(nombres, "PEREZ")       # ¿contiene el patrón? (vector lógico)
str_replace(nombres, "lopez", "López")  # reemplaza la primera coincidencia
str_split(str_trim(nombres), " ")  # separa por espacio -> lista de vectores

# paste()/paste0() (base R) para construir texto, muy usado en cualquier caso:
paste("Hola", "mundo")             # "Hola mundo" (separador " " por default)
paste0("ID-", 1:3)                 # "ID-1" "ID-2" "ID-3" (sin separador)

# Aplicado a un data frame real: manufacturer/model de mpg son texto.
datos %>%
  mutate(
    manufacturer = str_to_title(manufacturer),
    es_toyota    = str_detect(manufacturer, "Toyota")
  ) %>%
  select(manufacturer, model, es_toyota) %>%
  distinct()

# -----------------------------------------------------------------------------
# 6. Manejo de fechas con lubridate
# -----------------------------------------------------------------------------
# Base R maneja fechas con as.Date(), pero lubridate (parte del tidyverse) da
# funciones más legibles: ymd()/dmy()/mdy() para parsear según el orden de
# los componentes, sin pelearse con format().

fechas_texto <- c("2024-03-15", "2024-07-01", "2024-12-25")
fechas <- ymd(fechas_texto)     # "year-month-day" -- adivina el formato
fechas

# Extraer componentes:
year(fechas)
month(fechas)
day(fechas)
wday(fechas, label = TRUE)      # día de la semana (como texto: "vie", "lun"...)

# Aritmética de fechas: las diferencias regresan objetos "difftime"
hoy <- today()
hoy - fechas
as.numeric(hoy - fechas)        # como número, en días

# floor_date()/ceiling_date(): redondear una fecha a la unidad que quieras
floor_date(fechas, unit = "month")    # primer día del mes
ceiling_date(fechas, unit = "month")  # primer día del siguiente mes

# Aplicado a un data frame: agrupar ventas por mes es un patrón muy común
ventas <- tibble(
  fecha = ymd(c("2024-01-05", "2024-01-20", "2024-02-03", "2024-02-15")),
  monto = c(100, 150, 200, 90)
)

ventas %>%
  mutate(mes = floor_date(fecha, "month")) %>%
  group_by(mes) %>%
  summarize(total = sum(monto))

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Filtra `mpg` con cyl == 4 y selecciona solo manufacturer, model, cty, hwy.

# 2. Usa mutate() para crear una columna `hwy_km` = hwy * 1.60934
#    (millas a kilómetros) y ordénala de mayor a menor.

# 3. Encadena filter() %>% select() %>% arrange() en una sola expresión con
#    el pipe, usando una condición y columnas de tu elección.

# 4. Usando stringr, crea una columna nueva `model_mayus` con el nombre del
#    modelo en mayúsculas, y filtra solo los renglones donde `model`
#    contenga la letra "x" (usa str_detect() con ignore_case si hace falta).

# 5. Crea un vector de 5 fechas con ymd() y calcula cuántos días han pasado
#    desde cada una hasta hoy (today()). ¿Cuál día de la semana (wday) cayó
#    cada fecha?

# 6. Usando el data frame `ventas` del ejemplo de lubridate, agrega 4 filas
#    más con fechas de marzo y abril, y repite el group_by(mes) %>%
#    summarize() para ver el total por mes con los nuevos datos.

# =============================================================================
# EJEMPLO: limpiar y resumir un log de pedidos
# =============================================================================
# Combina dplyr, stringr y lubridate en un solo pipeline -- el tipo de
# limpieza que te vas a topar con datos reales casi todos los días.

pedidos <- tibble(
  cliente = c("  ana garcia", "LUIS PEREZ ", "Marta Lopez", "  ana garcia", "Iván Ruiz"),
  fecha   = c("2024-01-05", "2024-01-20", "2024-02-03", "2024-02-15", "2024-02-28"),
  monto   = c(450, 890, 120, 300, 670),
  estatus = c("pagado", "pendiente", "pagado", "pagado", "cancelado")
)

pedidos_limpios <- pedidos %>%
  mutate(
    cliente = str_to_title(str_trim(cliente)),   # limpia espacios y capitaliza
    fecha = ymd(fecha),
    mes = floor_date(fecha, "month")
  ) %>%
  filter(estatus == "pagado") %>%
  arrange(fecha)

pedidos_limpios

# Total pagado por cliente (algunos clientes repiten, como "Ana Garcia" con
# y sin espacios/mayúsculas -- por eso limpiamos el texto ANTES de agrupar)
# -- con tapply(), el mismo patrón de base R que ya conoces de la sesión 2c
tapply(pedidos_limpios$monto, pedidos_limpios$cliente, sum)

# En la sesión 4 vas a ver group_by() + summarize(), la forma idiomática de
# tidyverse para hacer justo este tipo de agregación dentro de un pipe.

# 7. Usando `pedidos`, filtra los pedidos con estatus == "pendiente" o
#    "cancelado", y calcula cuántos días han pasado (today() - fecha)
#    desde cada uno.

# 8. (Reto) Limpia el nombre de cliente en `pedidos` (sin filtrar nada) y
#    usa tapply() para contar cuántos pedidos hizo cada cliente, sin
#    importar el estatus.
