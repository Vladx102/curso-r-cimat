# Capítulo 1 — Vectores y tipos de datos

**Sesión 1 · Día 1, mañana · 2 horas**
Script de práctica: [`sesiones/sesion01_vectores_tipos.R`](../../sesiones/sesion01_vectores_tipos.R)

[← Capítulo 0](capitulo00_fundamentos_r.md) · [Índice](../../README.md) · [Capítulo 2 →](capitulo02_funciones_apply.md)

## Objetivo

Traducir tu experiencia previa de programación a los idiomas propios de R: vectores, tipos de datos, indexación desde 1 y vectorización. Si ya programas en otro lenguaje, este capítulo no te enseña a programar — te enseña los modismos específicos de R.

## 1. Consola, scripts y asignación

R usa `<-` como operador de asignación preferido, aunque `=` también funciona (por convención, `=` se reserva para argumentos dentro de una llamada a función).

```r
x <- 10
y = 20
x + y
```

Una particularidad de R frente a otros lenguajes: **casi todo es una función**, incluidos los operadores. `x + y` es azúcar sintáctica para:

```r
`+`(x, y)
```

Esto importa más adelante: entender que `+`, `[`, `<-` son funciones normales es lo que te permite, por ejemplo, sobrecargarlas para tus propias clases.

## 2. Tipos de datos atómicos

Los tipos básicos son similares a los de cualquier lenguaje, con una diferencia importante: **el tipo numérico por default es `double`, no `integer`**.

```r
class(1L)          # integer
class(1)           # double (¡ojo! no integer)
class("a")         # character
class(TRUE)        # logical
class(1 + 2i)      # complex
class(NA)          # logical por default, pero NA se adapta al contexto

typeof(1L); typeof(1)
```

## 3. Vectores: la unidad básica de R

A diferencia de Python o C, en R **no existen los escalares**. Un solo número es, técnicamente, un vector de longitud 1.

```r
v <- c(2, 4, 6, 8, 10)
v
length(v)
class(v)

is.vector(5)   # TRUE
```

Los vectores son homogéneos: si mezclas tipos, R los coerciona automáticamente al tipo "más general" (character > numeric > logical):

```r
c(1, "a", TRUE)     # todo pasa a character
c(1, TRUE)          # TRUE -> 1 (numeric)
```

## 4. Indexación: empieza en 1, no en 0

Esta es probablemente la primera fuente de errores para quien viene de un lenguaje 0-indexado.

```r
v[1]                 # primer elemento (¡no v[0]!)
v[c(1, 3)]            # varios índices
v[-1]                 # todo MENOS el primero
v[v > 5]              # indexación lógica -> patrón central en R
which(v > 5)          # posiciones que cumplen la condición
```

La indexación lógica (`v[v > 5]`) es, con diferencia, el patrón que más vas a usar en R. En vez de escribir un loop que pregunte condición por condición, le pasas un vector lógico de la misma longitud y R te regresa solo los elementos donde ese vector es `TRUE`.

## 5. Vectorización vs. loops

En R casi nunca escribes un `for` para operar elemento a elemento — las operaciones ya son vectorizadas y, en la práctica, órdenes de magnitud más rápidas que un loop explícito.

Este es el hábito que viene de otros lenguajes (funciona, pero no es idiomático):

```r
resultado <- numeric(length(v))
for (i in seq_along(v)) {
  resultado[i] <- v[i]^2
}
resultado
```

Esta es la forma idiomática en R:

```r
resultado <- v^2
```

Un efecto colateral de la vectorización es el **reciclaje**: si operas entre vectores de distinta longitud, R repite el más corto hasta emparejarlo con el más largo (avisando con un warning si no encajan de forma exacta).

```r
c(1, 2, 3, 4) + c(1, 2)          # se recicla c(1,2) -> c(1,2,1,2)
```

## Ejercicios

1. Crea un vector `v` con al menos 10 valores numéricos. Usando indexación lógica (sin `for`), obtén los elementos mayores a su propia media.
2. Practica `v[-1]`, `v[c(1,3,5)]` y `v[v %% 2 == 0]` sobre tu vector `v`.
3. **Reto:** reescribe de forma vectorizada el siguiente for-loop:

   ```r
   resultado <- c()
   for (i in 1:100) {
     if (i %% 3 == 0 || i %% 5 == 0) resultado <- c(resultado, i)
   }
   ```

---

[← Capítulo 0](capitulo00_fundamentos_r.md) · [Índice](../../README.md) · [Capítulo 2 →](capitulo02_funciones_apply.md)
