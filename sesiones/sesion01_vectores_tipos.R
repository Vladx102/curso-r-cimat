# =============================================================================
# Sesión 1 — Día 1 · mañana — Vectores y tipos de datos
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Traducir tu experiencia previa de programación a los idiomas propios de R:
#   vectores, tipos de datos, indexación desde 1 y vectorización.

# -----------------------------------------------------------------------------
# 1. Consola, scripts y asignación
# -----------------------------------------------------------------------------

x <- 10          # operador de asignación preferido: <-  (= también funciona)
y = 20           # válido, pero por convención se reserva para argumentos de función
x + y

# Todo en R es un objeto; casi todo es una función (incluso `+`)
`+`(x, y)

# -----------------------------------------------------------------------------
# 2. Tipos de datos atómicos
# -----------------------------------------------------------------------------

class(1L)          # integer
class(1)           # double (¡el default numérico es double, no integer!)
class("a")         # character
class(TRUE)        # logical
class(1 + 2i)      # complex
class(NA)          # logical por default, pero NA se adapta al contexto

typeof(1L); typeof(1)

# -----------------------------------------------------------------------------
# 3. Vectores: la unidad básica de R (no hay "escalares")
# -----------------------------------------------------------------------------

v <- c(2, 4, 6, 8, 10)
v
length(v)
class(v)

# Un solo número ES un vector de longitud 1
is.vector(5)

# Los vectores son homogéneos: la coerción es automática e implícita
c(1, "a", TRUE)     # todo pasa a character
c(1, TRUE)          # TRUE -> 1 (numeric)

# -----------------------------------------------------------------------------
# 4. Indexación: empieza en 1, no en 0
# -----------------------------------------------------------------------------

v[1]                 # primer elemento (¡no v[0]!)
v[c(1, 3)]            # varios índices
v[-1]                 # todo MENOS el primero
v[v > 5]              # indexación lógica -> patrón central en R
which(v > 5)          # posiciones que cumplen la condición

# -----------------------------------------------------------------------------
# 5. Vectorización vs. loops
# -----------------------------------------------------------------------------
# En R casi nunca escribes un for para operar elemento a elemento.
# Las operaciones ya son vectorizadas y muchísimo más rápidas.

# Mal hábito (viene de otros lenguajes):
resultado <- numeric(length(v))
for (i in seq_along(v)) {
  resultado[i] <- v[i]^2
}
resultado

# Forma idiomática en R:
v^2

# Reciclaje de vectores (broadcasting implícito, con warning si no encaja)
c(1, 2, 3, 4) + c(1, 2)          # se recicla c(1,2) -> c(1,2,1,2)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Crea un vector `v` con al menos 10 valores numéricos. Usando indexación
#    lógica (sin for), obtén los elementos mayores a su propia media.

# 2. Practica v[-1], v[c(1,3,5)] y v[v %% 2 == 0] sobre tu vector `v`.

# 3. (Reto) Reescribe el siguiente for-loop de forma vectorizada:
#    resultado <- c()
#    for (i in 1:100) {
#      if (i %% 3 == 0 || i %% 5 == 0) resultado <- c(resultado, i)
#    }
