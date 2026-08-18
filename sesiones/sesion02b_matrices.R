# =============================================================================
# Sesión 2b — Matrices
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Crear y operar con matrices, seleccionar filas/columnas/elementos, y
#   representar datos categóricos con factor(). Puente natural entre
#   vectores (sesión 1) y data frames (sesión 2c).

# -----------------------------------------------------------------------------
# 1. Matrices
# -----------------------------------------------------------------------------
# Una matriz es un vector con dos dimensiones (todos sus elementos son del
# mismo tipo, igual que un vector). Se crea con matrix().

m <- matrix(1:12, nrow = 3, ncol = 4)
m

# byrow = TRUE llena la matriz por filas en vez de por columnas (el default)
m2 <- matrix(1:12, nrow = 3, ncol = 4, byrow = TRUE)
m2

dim(m)        # dimensiones: filas, columnas
nrow(m)
ncol(m)

# -----------------------------------------------------------------------------
# 2. Operaciones con matrices
# -----------------------------------------------------------------------------

a <- matrix(1:4, nrow = 2)
b <- matrix(5:8, nrow = 2)

a + b            # suma elemento por elemento
a * b            # producto elemento por elemento (¡NO es multiplicación matricial!)
a %*% b          # multiplicación matricial real
t(a)             # transpuesta
solve(matrix(c(2, 0, 0, 2), nrow = 2))   # inversa (matriz debe ser cuadrada e invertible)

# -----------------------------------------------------------------------------
# 3. Filas y columnas
# -----------------------------------------------------------------------------

rownames(m) <- c("f1", "f2", "f3")
colnames(m) <- c("c1", "c2", "c3", "c4")
m

# Agregar una fila o columna nueva
rbind(m, c(100, 200, 300, 400))
cbind(m, c(1000, 2000, 3000))

# Sumar/promediar por fila o columna es tan común que tiene funciones dedicadas
rowSums(m)
colSums(m)
rowMeans(m)
colMeans(m)

# -----------------------------------------------------------------------------
# 4. Seleccionar elementos de una matriz
# -----------------------------------------------------------------------------
# El patrón general es m[fila, columna]. Dejar un lado vacío selecciona
# "todas" las filas o columnas.

m[1, 2]        # elemento en la fila 1, columna 2
m[1, ]         # toda la fila 1
m[, 2]         # toda la columna 2
m[1:2, c(1, 3)]  # sub-matriz: filas 1-2, columnas 1 y 3

# También puedes indexar por nombre, si le pusiste rownames/colnames
m["f1", "c2"]

# -----------------------------------------------------------------------------
# 5. Categorías con la función factor()
# -----------------------------------------------------------------------------
# factor() representa datos categóricos: un vector de character con un
# conjunto fijo y (opcionalmente) ordenado de "niveles" (levels).

talla <- c("M", "S", "L", "M", "S", "L", "L")
talla_factor <- factor(talla)
talla_factor
levels(talla_factor)
table(talla_factor)      # conteo por categoría

# factor ordenado: importa el orden de las categorías
satisfaccion <- factor(
  c("bajo", "alto", "medio", "alto"),
  levels = c("bajo", "medio", "alto"),
  ordered = TRUE
)
satisfaccion
satisfaccion[1] < satisfaccion[2]   # "bajo" < "alto" -> TRUE, gracias al orden

# =============================================================================
# EJERCICIO
# =============================================================================

# Crea una matriz `notas` de 4 alumnos (filas) x 3 exámenes (columnas) con
# calificaciones entre 0 y 100 (tú eliges los valores). Luego:
#   a) ponle nombres a las filas (alumno1, alumno2, ...) y a las columnas
#      (examen1, examen2, examen3)
#   b) calcula el promedio de cada alumno (por fila)
#   c) calcula el promedio de cada examen (por columna)
#   d) crea un factor `aprobado` que sea "sí" si el promedio del alumno
#      es mayor o igual a 60, y "no" en caso contrario

# =============================================================================
# SOLUCIÓN AL EJERCICIO
# =============================================================================

notas <- matrix(
  c(85, 70, 90, 60, 55, 75, 95, 88, 92, 40, 45, 50),
  nrow = 4, ncol = 3, byrow = TRUE
)
rownames(notas) <- paste0("alumno", 1:4)
colnames(notas) <- paste0("examen", 1:3)
notas

promedio_alumno <- rowMeans(notas)
promedio_alumno

promedio_examen <- colMeans(notas)
promedio_examen

aprobado <- factor(ifelse(promedio_alumno >= 60, "sí", "no"))
aprobado

# =============================================================================
# EJEMPLO: ventas mensuales por sucursal
# =============================================================================

ventas <- matrix(
  c(120, 135, 150, 300, 280, 310, 90, 95, 100, 200, 210, 190),
  nrow = 4, byrow = TRUE
)
rownames(ventas) <- c("Centro", "Norte", "Sur", "Poniente")
colnames(ventas) <- c("Ene", "Feb", "Mar")
ventas

# Total por sucursal (por fila) y quién vendió más en el trimestre
total_sucursal <- rowSums(ventas)
total_sucursal
rownames(ventas)[which.max(total_sucursal)]

# Crecimiento de enero a marzo, por sucursal, como porcentaje
crecimiento <- (ventas[, "Mar"] - ventas[, "Ene"]) / ventas[, "Ene"] * 100
round(crecimiento, 1)

# Clasificar sucursales por desempeño total con un factor ordenado
desempeno <- ifelse(total_sucursal >= 600, "alta",
              ifelse(total_sucursal >= 300, "media", "baja"))
desempeno <- factor(desempeno, levels = c("baja", "media", "alta"), ordered = TRUE)
data.frame(sucursal = rownames(ventas), total = total_sucursal, desempeno)

# ¿Qué proporción de las ventas totales del trimestre aportó cada sucursal?
proporcion <- total_sucursal / sum(ventas)
round(proporcion * 100, 1)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 2. Crea tu propia matriz `produccion` de 3 fábricas (filas) x 4 trimestres
#    (columnas) con valores inventados. Calcula qué trimestre tuvo más
#    producción combinando TODAS las fábricas (usa colSums()).

# 3. (Reto) Crea una matriz `temperaturas` de 3 ciudades x 4 estaciones del
#    año con valores inventados. Usando %*%, multiplícala por un vector de
#    pesos c(0.25, 0.25, 0.25, 0.25) para obtener, en una sola operación,
#    el promedio anual ponderado de cada ciudad.
