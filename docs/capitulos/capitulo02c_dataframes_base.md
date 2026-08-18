# Capítulo 2c — Data Frames en base R

**Sesión 2c · 2 horas**
Script de práctica: [`sesiones/sesion02c_dataframes_base.R`](../../sesiones/sesion02c_dataframes_base.R)

[← Capítulo 2b](capitulo02b_matrices.md) · [Índice](../../README.md) · [Capítulo 3 →](capitulo03_importacion_dplyr.md)

## Objetivo

Crear data frames con las herramientas de base R (sin tidyverse), explorar los datasets de ejemplo incluidos en R, seleccionar y ordenar filas/columnas, exportar e importar CSV, tratar valores nulos, y operar por fila o columna. El [capítulo 3](capitulo03_importacion_dplyr.md) retoma todo esto con `tibble`/dplyr — mucho más cómodo para el trabajo diario — pero vale la pena conocer primero la base sobre la que está construido el tidyverse.

## 1. Crear nuestro primer Data Frame

Un `data.frame` es una tabla: cada columna es un vector (todas del mismo largo), y las columnas pueden ser de tipos distintos entre sí — a diferencia de una matriz, donde todo tiene que ser del mismo tipo.

```r
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
```

## 2. Conjuntos de datos de ejemplo en RStudio

R y muchos paquetes traen datasets incluidos, útiles para practicar sin necesidad de archivos externos — el curso entero los usa (`mpg`, `mtcars`, `warpbreaks`) precisamente para que puedas correr cada script sin depender de datos propios.

```r
data()                    # lista todos los datasets disponibles (se abre
                           # en el visor); library(help = "datasets") es
                           # el equivalente en texto plano

head(mtcars)               # primeras 6 filas
head(iris, 3)               # primeras 3 filas
?mtcars                     # documentación del dataset: qué significa cada columna
```

## 3. Selección y ordenación de Data Frames

En base R (sin dplyr) hay varias formas equivalentes de extraer una columna:

```r
estudiantes$nombre               # una columna, como vector
estudiantes[, "nombre"]           # equivalente
estudiantes[["promedio"]]         # también equivalente
```

Y el mismo patrón `[fila, columna]` de las matrices funciona para data frames:

```r
estudiantes[1, ]                  # primera fila (todas las columnas)
estudiantes[1:2, c("nombre", "edad")]   # sub-tabla: filas 1-2, columnas elegidas
estudiantes[estudiantes$becado, ]        # filas donde becado es TRUE
```

Para ordenar, `order()` no reordena los valores directamente — regresa las **posiciones** que los ordenarían, y esas posiciones se usan para indexar el data frame:

```r
orden <- order(estudiantes$promedio, decreasing = TRUE)
estudiantes[orden, ]
```

## 4. Exportar e importar ficheros de tipo CSV

```r
write.csv(estudiantes, "estudiantes.csv", row.names = FALSE)
estudiantes_leidos <- read.csv("estudiantes.csv")
```

`row.names = FALSE` evita que R agregue una columna extra con el número de fila al exportar — es un olvido muy común la primera vez que se usa `write.csv()`, y produce un CSV con una columna `X` fea al importarlo de vuelta.

## 5. Tratamiento de valores nulos

`NA` (*Not Available*) es el valor nulo/faltante de R. Un data frame real casi siempre tiene `NA`s, y hay que decidir explícitamente qué hacer con ellos — R nunca los ignora silenciosamente.

```r
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
```

Para quedarte solo con las filas completas:

```r
complete.cases(con_nulos)
con_nulos[complete.cases(con_nulos), ]

# na.omit() hace lo mismo de un solo paso: elimina filas con al menos un NA
na.omit(con_nulos)
```

Y para **imputar** en vez de eliminar — reemplazar el `NA` con un valor razonable, como la media de la columna:

```r
con_nulos$edad[is.na(con_nulos$edad)] <- mean(con_nulos$edad, na.rm = TRUE)
con_nulos
```

Eliminar filas con `na.omit()` es más simple pero pierde información; imputar (o modelar los NAs explícitamente) es más trabajo pero conserva las observaciones. Cuál conviene depende del contexto — no hay una regla universal.

## 6. Operaciones por filas

`apply(datos, MARGIN, funcion)` aplica una función por fila (`MARGIN = 1`) o por columna (`MARGIN = 2`).

```r
notas <- estudiantes[, c("edad", "promedio")]
apply(notas, 1, sum)          # suma de cada fila
apply(notas, 1, mean)          # promedio de cada fila
```

## 7. Operaciones por columnas

```r
apply(notas, 2, mean)
apply(notas, 2, sd)
```

Para sumas y promedios por columna específicamente, R trae atajos más rápidos que `apply()` (ya los usamos con matrices en el capítulo 2b):

```r
colSums(notas)
colMeans(notas)
```

## Ejercicio

Usando el dataset incluido `mtcars`:

a. crea un sub-data.frame `autos_eficientes` con los autos cuyo `mpg` (millas por galón) sea mayor a 20
b. ordénalo de mayor a menor `mpg`
c. calcula, con `apply()`, el promedio de las columnas `mpg`, `hp` y `wt` sobre **todo** `mtcars` (no solo `autos_eficientes`)
d. exporta `autos_eficientes` a un archivo CSV llamado `autos_eficientes.csv` sin la columna de nombres de fila
e. toma `con_nulos` (del punto 5) y crea una versión `con_nulos_completo` donde el `NA` de `promedio` se reemplaza por la media de esa columna, igual que se hizo arriba con `edad`

## Ejemplo elaborado: nómina de una empresa pequeña

```r
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
```

`tapply(valores, grupo, funcion)` aplica una función **por grupo**, sin necesidad de dplyr todavía — es el equivalente en base R de `group_by()` + `summarize()`, que verás en el [capítulo 3](capitulo03_importacion_dplyr.md):

```r
promedio_por_depto <- tapply(empleados$compensacion_total, empleados$departamento, mean)
promedio_por_depto
names(promedio_por_depto)[which.max(promedio_por_depto)]
```

Vale la pena quedarse con esta comparación en la cabeza: `tapply()` resuelve en una línea lo que en dplyr se escribe como `group_by(departamento) %>% summarize(mean(compensacion_total))`. Ambos hacen exactamente lo mismo — dplyr solo lo hace más legible cuando encadenas varios pasos.

## Ejercicios adicionales

2. Usando `empleados`, calcula qué porcentaje de la compensación total de la empresa corresponde a cada departamento (usa `tapply()` y `sum()`).
3. **Reto:** agrega una columna `antiguedad` (años en la empresa, inventa valores) a `empleados`. Usando `order()` con **dos** criterios (ver `?order`), ordena primero por departamento y luego por salario descendente dentro de cada departamento.

---

[← Capítulo 2b](capitulo02b_matrices.md) · [Índice](../../README.md) · [Capítulo 3 →](capitulo03_importacion_dplyr.md)
