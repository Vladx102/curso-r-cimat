# =============================================================================
# Sesión 2c — Data Frames en base R
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Crear data frames con las herramientas de base R (sin tidyverse),
#   explorar los datasets de ejemplo incluidos en R, seleccionar y ordenar
#   filas/columnas, exportar e importar CSV, tratar valores nulos, y
#   operar por fila o columna. La sesión 3 retoma todo esto con
#   tibble/dplyr, mucho más cómodo para trabajo diario — pero vale la
#   pena conocer primero la base sobre la que está construido el
#   tidyverse.

# -----------------------------------------------------------------------------
# 1. Crear nuestro primer Data Frame
# -----------------------------------------------------------------------------
# Un data.frame es una tabla: cada columna es un vector (todas del mismo
# largo), y las columnas pueden ser de tipos distintos entre sí.

estudiantes <- data.frame(
  nombre = c("Ana", "Luis", "Carla", "Diego"),
  edad = c(23, 25, 22, 24),
  promedio = c(8.5, 7.2, 9.1, 6.8),
  becado = c(TRUE, FALSE, TRUE, FALSE)
)
estudiantes

str(estudiantes)     # estructura: tipo de cada columna
summary(estudiantes)  # resumen estadístico de cada columna
nrow(estudiantes)
ncol(estudiantes)
dim(estudiantes)

# -----------------------------------------------------------------------------
# 2. Conjuntos de datos de ejemplo en RStudio
# -----------------------------------------------------------------------------
# R (y muchos paquetes) traen datasets incluidos, útiles para practicar sin
# necesidad de archivos externos.

data()                    # lista todos los datasets disponibles (se abre
                           # en el visor); library(help = "datasets") es
                           # el equivalente en texto plano

head(mtcars)               # primeras 6 filas
head(iris, 3)               # primeras 3 filas
?mtcars                     # documentación del dataset: qué significa cada columna

# -----------------------------------------------------------------------------
# 3. Selección y ordenación de Data Frames
# -----------------------------------------------------------------------------

estudiantes$nombre               # una columna, como vector
estudiantes[, "nombre"]           # equivalente
estudiantes[["promedio"]]         # también equivalente

estudiantes[1, ]                  # primera fila (todas las columnas)
estudiantes[1:2, c("nombre", "edad")]   # sub-tabla: filas 1-2, columnas elegidas
estudiantes[estudiantes$becado, ]        # filas donde becado es TRUE

# Ordenar con order(): regresa las POSICIONES ordenadas, no los valores
orden <- order(estudiantes$promedio, decreasing = TRUE)
estudiantes[orden, ]

# -----------------------------------------------------------------------------
# 4. Exportar e importar ficheros de tipo CSV
# -----------------------------------------------------------------------------

# write.csv(estudiantes, "estudiantes.csv", row.names = FALSE)
# estudiantes_leidos <- read.csv("estudiantes.csv")

# row.names = FALSE evita que R agregue una columna extra con el número de
# fila al exportar (un error muy común la primera vez que se usa write.csv).

# -----------------------------------------------------------------------------
# 5. Tratamiento de valores nulos
# -----------------------------------------------------------------------------
# NA (Not Available) es el valor nulo/faltante de R. Un data frame real casi
# siempre tiene NAs, y hay que decidir explícitamente qué hacer con ellos.

con_nulos <- data.frame(
  nombre = c("Ana", "Luis", "Carla", "Diego"),
  edad = c(23, NA, 22, 24),
  promedio = c(8.5, 7.2, NA, 6.8)
)
con_nulos

is.na(con_nulos)              # matriz lógica: TRUE donde hay NA
is.na(con_nulos$edad)          # solo en una columna
sum(is.na(con_nulos))          # cuántos NA hay en total
colSums(is.na(con_nulos))      # cuántos NA hay por columna

# Filas completas (sin ningún NA)
complete.cases(con_nulos)
con_nulos[complete.cases(con_nulos), ]

# na.omit() hace lo mismo de un solo paso: elimina filas con al menos un NA
na.omit(con_nulos)

# Reemplazar NAs con un valor (ej. la media de la columna) en vez de
# eliminar la fila completa
con_nulos$edad[is.na(con_nulos$edad)] <- mean(con_nulos$edad, na.rm = TRUE)
con_nulos

# -----------------------------------------------------------------------------
# 6. Operaciones por filas
# -----------------------------------------------------------------------------
# apply(datos, MARGIN, funcion): MARGIN = 1 aplica la función a cada FILA.

notas <- estudiantes[, c("edad", "promedio")]
apply(notas, 1, sum)          # suma de cada fila
apply(notas, 1, mean)          # promedio de cada fila

# -----------------------------------------------------------------------------
# 7. Operaciones por columnas
# -----------------------------------------------------------------------------
# MARGIN = 2 aplica la función a cada COLUMNA (equivalente a sapply()
# sobre el data frame, que ya usamos en la sesión 2).

apply(notas, 2, mean)
apply(notas, 2, sd)

colSums(notas)     # atajo para sumas por columna (más rápido que apply)
colMeans(notas)     # atajo para promedios por columna

# =============================================================================
# EJERCICIO
# =============================================================================

# Usando el dataset incluido `mtcars`:
#   a) crea un sub-data.frame `autos_eficientes` con los autos cuyo mpg
#      (millas por galón) sea mayor a 20
#   b) ordénalo de mayor a menor mpg
#   c) calcula, con apply(), el promedio de las columnas mpg, hp y wt
#      sobre TODO mtcars (no solo autos_eficientes)
#   d) exporta autos_eficientes a un archivo CSV llamado "autos_eficientes.csv"
#      sin la columna de nombres de fila
#   e) toma `con_nulos` (del punto 5) y crea una versión `con_nulos_completo`
#      donde el NA de `promedio` se reemplaza por la media de esa columna,
#      igual que se hizo arriba con `edad`

# =============================================================================
# EJEMPLO: nómina de una empresa pequeña
# =============================================================================

empleados <- data.frame(
  nombre = c("Ana", "Beto", "Carla", "Daniel", "Elena", "Fer"),
  departamento = c("Ventas", "IT", "Ventas", "IT", "RH", "Ventas"),
  salario = c(15000, 22000, 17500, 25000, 16000, 14000),
  bono = c(1000, NA, 800, 1500, NA, 900)
)
empleados

# Salario total y promedio de toda la empresa
sum(empleados$salario)
mean(empleados$salario)

# Empleados de IT, ordenados por salario descendente
empleados_it <- empleados[empleados$departamento == "IT", ]
empleados_it[order(empleados_it$salario, decreasing = TRUE), ]

# Reemplazar los NA de bono con 0 (asumimos que sin dato = no le tocó bono)
empleados$bono[is.na(empleados$bono)] <- 0
empleados

# Compensación total (salario + bono) por fila con apply()
empleados$compensacion_total <- apply(empleados[, c("salario", "bono")], 1, sum)
empleados

# tapply(valores, grupo, funcion): aplica una función POR GRUPO, sin
# necesidad de dplyr todavía -- es el equivalente base R de group_by()+
# summarize(), que verás en la sesión 3.
promedio_por_depto <- tapply(empleados$compensacion_total, empleados$departamento, mean)
promedio_por_depto
names(promedio_por_depto)[which.max(promedio_por_depto)]

# =============================================================================
# EJERCICIOS
# =============================================================================

# 2. Crea un data.frame `ventas_tienda` con columnas vendedor, sucursal y
#    monto (al menos 6 filas, 2-3 sucursales distintas). Usando tapply() y
#    sum(), calcula qué porcentaje del total vendido corresponde a cada
#    sucursal.

# 3. (Reto) Agrega una columna `anios_experiencia` a `ventas_tienda`. Usando
#    order() con DOS criterios (ver ?order), ordénalo primero por sucursal
#    y luego por monto descendente dentro de cada sucursal.
