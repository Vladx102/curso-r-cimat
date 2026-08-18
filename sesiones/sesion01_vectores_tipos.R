# =============================================================================
# Sesión 1 — Día 1 · mañana — Vectores y tipos de datos
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Traducir tu experiencia previa de programación a los idiomas propios de R:
#   vectores, tipos de datos, indexación desde 1 y vectorización. Retomamos
#   directo desde donde quedó la sesión 0 -- lo que ya viste ahí (asignación
#   básica, class(), crear vectores con c(), v[1]/indexación lógica) no se
#   repite aquí; esta sesión va a lo que falta.

# -----------------------------------------------------------------------------
# 1. Todo es una función (incluso los operadores)
# -----------------------------------------------------------------------------
# Ya asignaste variables con <- en la sesión 0. Una particularidad de R
# frente a otros lenguajes que ahí no vimos: CASI TODO es una función,
# incluidos los operadores.

x <- 10
y <- 20     # `=` también es válido para asignar, pero por convención se
            # reserva para argumentos dentro de una llamada a función
x + y

# x + y es azúcar sintáctica para:
`+`(x, y)

# Esto importa más adelante: entender que +, [, <- son funciones normales
# es lo que te permite, por ejemplo, sobrecargarlas para tus propias clases.

# -----------------------------------------------------------------------------
# 2. Tipos de datos atómicos: más allá de class()
# -----------------------------------------------------------------------------
# En la sesión 0 ya viste class() sobre numeric/integer/character/logical.
# Dos cosas que faltaban ahí: typeof() y el tipo complex.

typeof(1L); typeof(1)     # class() dice "numeric" para ambos; typeof() sí
                            # distingue "integer" de "double"

class(1 + 2i)               # complex: los números complejos son otro tipo atómico

# -----------------------------------------------------------------------------
# 3. Vectores: no hay "escalares"
# -----------------------------------------------------------------------------
# Ya creaste vectores con c() en la sesión 0. Lo que faltaba: en R un solo
# número ES un vector de longitud 1 -- no existen los escalares como tipo
# aparte, a diferencia de Python o C.

v <- c(2, 4, 6, 8, 10)
length(v)
is.vector(5)   # TRUE: hasta un solo número es un vector

# Los vectores son homogéneos: si mezclas tipos, R los coerciona
# automáticamente al tipo "más general" (character > numeric > logical):
c(1, "a", TRUE)     # todo pasa a character
c(1, TRUE)          # TRUE -> 1 (numeric)

# -----------------------------------------------------------------------------
# 4. Indexación: lo que falta más allá de v[1] y la indexación lógica
# -----------------------------------------------------------------------------
# En la sesión 0 ya usaste v[1], v[c(1,3)] y la indexación lógica v[v > x].
# Dos patrones más que vas a usar seguido:

v[-1]                 # índice negativo: todo MENOS el primero
which(v > 5)           # las POSICIONES que cumplen la condición (no los valores)

# v[v > 5] te da los VALORES; which(v > 5) te da los ÍNDICES donde eso pasa.
# Se combinan: v[which(v > 5)] es equivalente a v[v > 5], pero which() es
# más explícito cuando necesitas la posición en sí (p.ej. which.max()).

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
