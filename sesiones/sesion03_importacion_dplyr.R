# =============================================================================
# Sesión 3 — Día 2 · mañana — Importación de datos y verbos de dplyr
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Distinguir data.frame de tibble, importar datos con readr, dominar
#   filter/select/mutate/arrange encadenados con el pipe, y manejar cadenas
#   de texto con stringr.

# install.packages("tidyverse")   # ejecutar una sola vez si falta
library(tidyverse)

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
