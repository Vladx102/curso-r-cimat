# Introducción a R para Modelación Estadística

Curso de nivelación — Maestría en Ciencias, CIMAT Aguascalientes

*Duración: 10 sesiones · 2 horas cada una (20 horas totales) · 5 días, 2 sesiones al día*

## Presentación

Curso intensivo de nivelación dirigido a estudiantes de nuevo ingreso a la maestría del CIMAT Aguascalientes, previo al curso de Modelación Estadística. Está diseñado para alumnos que ya saben programar en algún otro lenguaje (Python, C/C++, MATLAB, etc.), por lo que no se dedica tiempo a conceptos generales de programación: el curso va directo a la sintaxis y los idiomas propios de R, y dedica la mayor parte del tiempo a su aplicación en modelación estadística.

## Objetivos

- Traducir el conocimiento de programación previo a los idiomas propios de R (vectorización, data frames, tidyverse).
- Manipular, limpiar y visualizar datos de forma eficiente con el ecosistema tidyverse.
- Producir análisis reproducibles con Quarto/R Markdown.
- Ajustar, interpretar y diagnosticar modelos lineales y lineales generalizados (`lm`, `glm`) en R.
- Llegar al curso de Modelación Estadística con soltura técnica en R, sin depender de tiempo de clase para aprender el lenguaje.

## Dirigido a

Alumnos de nuevo ingreso a la maestría del CIMAT Aguascalientes, con experiencia previa en programación en cualquier lenguaje y sin necesariamente experiencia previa en R.

## Metodología

- 10 sesiones de 2 horas, repartidas en 5 días (mañana y tarde): exposición breve de conceptos + práctica guiada en RStudio/Posit.
- Aprendizaje por comparación con otros lenguajes ("esto es como X, pero...").
- Ejercicios cortos al final de cada sesión y un mini-proyecto integrador en la última sesión.
- Todo el material se organiza por sesión en [`sesiones/`](../sesiones).

## Temario

| Sesión | Momento | Tema | Contenidos |
|---|---|---|---|
| 1 | Día 1 · mañana | Vectores y tipos de datos | Consola, scripts y proyectos (.Rproj) · Tipos de datos y vectores; indexación desde 1 y reciclaje · Vectorización vs. loops |
| 2 | Día 1 · tarde | Funciones y familia apply | Control de flujo y manejo de NA · Funciones propias (default, `...`) · Listas y familia apply (`sapply`, `lapply`, `vapply`) |
| 3 | Día 2 · mañana | Importación y verbos de dplyr | `data.frame` vs. `tibble`; importación con readr · El pipe `%>%` · dplyr: `filter`, `select`, `mutate`, `arrange` |
| 4 | Día 2 · tarde | Agregación, tidyr y ggplot2 | `group_by()` + `summarize()` · tidyr: `pivot_longer`/`wider`, joins · ggplot2: gramática de gráficos, geoms y facetas |
| 5 | Día 3 · mañana | Proyectos reproducibles | Organización de proyectos y buenas prácticas · Quarto/R Markdown · Documentar y reutilizar funciones propias |
| 6 | Día 3 · tarde | Cómputo estadístico y simulación | Distribuciones en R: familias d/p/q/r · Números aleatorios y semillas (`set.seed`) · Simulación Monte Carlo: ley de grandes números y TLC |
| 7 | Día 4 · mañana | Regresión lineal | Fórmulas en R (`y ~ x`) · `lm()`: ajuste, `summary()` y coeficientes · Factores, niveles de referencia y contrastes |
| 8 | Día 4 · tarde | Diagnóstico y ANOVA | Interacciones entre predictores · Diagnóstico de supuestos: residuos, `plot.lm()`, colinealidad · ANOVA y modelos anidados |
| 9 | Día 5 · mañana | Modelos lineales generalizados | `glm()`: regresión logística y de Poisson · Selección de modelos: AIC/BIC, `step()` |
| 10 | Día 5 · tarde | Validación y cierre | Validación: train/test, validación cruzada básica · broom (`tidy`, `glance`, `augment`) · Mini-proyecto integrador y retroalimentación |

## Evaluación

- **Ejercicios de práctica por sesión (40%):** entregables cortos al cierre de cada una de las 10 sesiones.
- **Mini-proyecto integrador (60%):** análisis reproducible en Quarto que incluya limpieza de datos, visualización y al menos un modelo (`lm` o `glm`) con su interpretación, entregado al finalizar la sesión 10.

Carácter no numérico: al ser un curso de nivelación, la evaluación tiene como fin retroalimentar al estudiante, no calificar para créditos del programa (salvo que el comité académico indique lo contrario).

## Requisitos previos

- Experiencia de programación en al menos un lenguaje (cualquiera).
- Laptop propia con R y RStudio (o Positron/VS Code) instalados antes de la sesión 1.
- No se requiere experiencia previa en R ni en estadística más allá de un curso básico de probabilidad y estadística de licenciatura.

## Material y software

- R (versión reciente) y RStudio Desktop, o Positron.
- Paquetes: tidyverse, broom, car, quarto (o rmarkdown). Ver [`install.R`](../install.R).
- Scripts de práctica por sesión en [`sesiones/`](../sesiones).
