# Introducción a R para Modelación Estadística

Curso de nivelación — Maestría en Ciencias, CIMAT Aguascalientes

*Duración: 13 sesiones · 2 horas cada una (26 horas totales)*

> El desarrollo teórico de cada sesión está en [`capitulos/`](capitulos/capitulo00_fundamentos_r.md); el código ejecutable equivalente está en [`sesiones/`](../sesiones). Antes de la sesión 0, sigue la [guía de instalación](instalacion.md).

## Presentación

Curso intensivo de nivelación dirigido a estudiantes de nuevo ingreso a la maestría del CIMAT Aguascalientes, previo al curso de Modelación Estadística. La columna vertebral del curso (sesiones 1 en adelante) está diseñada para alumnos que ya saben programar en algún otro lenguaje (Python, C/C++, MATLAB, etc.), por lo que no se detiene en conceptos generales de programación: va directo a la sintaxis y los idiomas propios de R, y dedica la mayor parte del tiempo a su aplicación en modelación estadística. Las sesiones 0, 2b y 2c cubren fundamentos de R desde cero (aritmética, matrices, data frames en base R) para quien las necesite como punto de partida o repaso — son opcionales para quien ya tiene ese terreno cubierto.

## Objetivos

- Traducir el conocimiento de programación previo a los idiomas propios de R (vectorización, matrices, data frames, tidyverse).
- Manipular, limpiar y visualizar datos de forma eficiente, tanto con base R como con el ecosistema tidyverse.
- Producir análisis reproducibles con Quarto/R Markdown.
- Ajustar, interpretar y diagnosticar modelos lineales y lineales generalizados (`lm`, `glm`) en R.
- Llegar al curso de Modelación Estadística con soltura técnica en R, sin depender de tiempo de clase para aprender el lenguaje.

## Dirigido a

Alumnos de nuevo ingreso a la maestría del CIMAT Aguascalientes. Las sesiones 1 en adelante asumen experiencia previa en programación en cualquier lenguaje, sin necesariamente experiencia previa en R; las sesiones 0, 2b y 2c no asumen ningún conocimiento previo de R.

## Metodología

- 13 sesiones de 2 horas: exposición breve de conceptos + práctica guiada en RStudio/Posit. Pensado originalmente como 2 sesiones por día (mañana y tarde), pero la cadencia la puede ajustar quien imparta el curso.
- Aprendizaje por comparación con otros lenguajes ("esto es como X, pero...").
- Ejercicios cortos al final de cada sesión (algunos con solución incluida) y un mini-proyecto integrador en la última sesión.
- Todo el material se organiza por sesión en [`sesiones/`](../sesiones) (código) y [`capitulos/`](capitulos) (teoría en prosa).

## Temario

| Sesión | Tema | Contenidos |
|---|---|---|
| 0 | Fundamentos de R | Operaciones aritméticas · Variables y tipos de datos · Primer contacto con vectores · Operadores de comparación · Ayuda y documentación (`?`, `help()`) · Instalar y cargar librerías (`install.packages`, `library`, CRAN) · Ejercicio con solución |
| 1 | Vectores y tipos de datos | Consola, scripts y proyectos (.Rproj) · Tipos de datos y vectores; indexación desde 1 y reciclaje · Vectorización vs. loops |
| 2 | Funciones y familia apply | Manejo de NA · Estructuras de control (`for`, `if`/`else`, `while`, `repeat`, `break`/`next`, `switch`) · Funciones propias (default, `...`, `return()`, anónimas, ámbito, recursión) · Listas y familia apply (`sapply`, `lapply`, `vapply`) |
| 2b | Matrices | Creación y operaciones con matrices · Filas y columnas (`rbind`, `cbind`, `rowSums`...) · Selección de elementos · Categorías con `factor()` · Ejercicio con solución |
| 2c | Data Frames en base R | Crear un `data.frame` · Datasets de ejemplo incluidos en R · Selección y ordenación (`order()`) · Exportar/importar CSV · Tratamiento de valores nulos (`is.na()`, `na.omit()`, imputación) · Operaciones por fila y columna (`apply()`) |
| 3 | Importación y verbos de dplyr | `data.frame` vs. `tibble`; importación con readr · El pipe `%>%` · dplyr: `filter`, `select`, `mutate`, `arrange` · Manejo de cadenas con stringr (`str_detect`, `str_replace`, `str_split`...) |
| 4 | Agregación, tidyr y ggplot2 | `group_by()` + `summarize()` · tidyr: `pivot_longer`/`wider`, joins · ggplot2: gramática de gráficos, geoms y facetas |
| 5 | Proyectos reproducibles | Organización de proyectos y buenas prácticas · Quarto/R Markdown · Documentar y reutilizar funciones propias |
| 6 | Cómputo estadístico y simulación | Distribuciones en R: familias d/p/q/r · Números aleatorios y semillas (`set.seed`) · Simulación Monte Carlo: ley de grandes números y TLC · Generar datasets ficticios (fechas, categorías, IDs) |
| 7 | Regresión lineal | Fórmulas en R (`y ~ x`) · `lm()`: ajuste, `summary()` y coeficientes · Factores, niveles de referencia y contrastes |
| 8 | Diagnóstico y ANOVA | Interacciones entre predictores · Diagnóstico de supuestos: residuos, `plot.lm()`, colinealidad · ANOVA y modelos anidados |
| 9 | Modelos lineales generalizados | `glm()`: regresión logística y de Poisson · Selección de modelos: AIC/BIC, `step()` |
| 10 | Validación y cierre | Validación: train/test, validación cruzada básica · broom (`tidy`, `glance`, `augment`) · Mini-proyecto integrador y retroalimentación |

## Evaluación

- **Ejercicios de práctica por sesión (40%):** entregables cortos al cierre de cada sesión.
- **Mini-proyecto integrador (60%):** análisis reproducible en Quarto que incluya limpieza de datos, visualización y al menos un modelo (`lm` o `glm`) con su interpretación, entregado al finalizar la sesión 10.

Carácter no numérico: al ser un curso de nivelación, la evaluación tiene como fin retroalimentar al estudiante, no calificar para créditos del programa (salvo que el comité académico indique lo contrario).

## Requisitos previos

- Ninguno para las sesiones 0, 2b y 2c (parten de cero).
- Para las sesiones 1 en adelante: experiencia de programación en al menos un lenguaje (cualquiera).
- Laptop propia con R y RStudio (o Positron/VS Code) instalados antes de la sesión 0 — ver la [guía de instalación](instalacion.md).
- No se requiere experiencia previa en estadística más allá de un curso básico de probabilidad y estadística de licenciatura.

## Material y software

- R (versión reciente) y RStudio Desktop, o Positron.
- Paquetes: tidyverse, broom, car, quarto (o rmarkdown). Ver [`install.R`](../install.R).
- Scripts de práctica por sesión en [`sesiones/`](../sesiones); teoría en prosa en [`capitulos/`](capitulos).
