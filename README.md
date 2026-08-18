# Curso de nivelación en R — CIMAT Aguascalientes

Material de un curso intensivo de R para alumnos de nuevo ingreso a la maestría del CIMAT Aguascalientes, previo al curso de Modelación Estadística. Está pensado para estudiantes que ya saben programar en algún otro lenguaje, así que va directo a los idiomas propios de R (vectorización, tidyverse, modelación) sin detenerse en conceptos generales de programación — con un par de sesiones adicionales de fundamentos (aritmética, matrices, data frames base) para quien las necesite como referencia o repaso.

**13 sesiones de 2 horas · 26 horas totales.**

El temario completo está en [`docs/silabo.md`](docs/silabo.md). Antes de la sesión 0, sigue la [guía de instalación](docs/instalacion.md).

## Estructura del repositorio

```
curso-r-cimat/
├── curso-r-cimat.Rproj      # abre el proyecto en RStudio/Posit
├── install.R                # instala las dependencias del curso
├── docs/
│   ├── instalacion.md       # guía de preparación previa (R, RStudio, tour de la interfaz)
│   ├── silabo.md            # temario, objetivos y evaluación
│   └── capitulos/           # material teórico en Markdown, uno por sesión
│       ├── capitulo00_fundamentos_r.md
│       ├── capitulo01_vectores_tipos.md
│       ├── capitulo02_funciones_apply.md
│       ├── capitulo02b_matrices.md
│       ├── capitulo02c_dataframes_base.md
│       ├── ...
│       └── capitulo10_validacion_cierre.md
└── sesiones/                # scripts .R de práctica, uno por sesión
    ├── sesion00_fundamentos_r.R
    ├── sesion01_vectores_tipos.R
    ├── sesion02_funciones_apply.R
    ├── sesion02b_matrices.R
    ├── sesion02c_dataframes_base.R
    ├── ...
    └── sesion10_validacion_cierre.R
```

Cada capítulo en `docs/capitulos/` explica la teoría en prosa con ejemplos de código; el script equivalente en `sesiones/` es la versión ejecutable, con el mismo código y una sección de ejercicios al final.

## Temario

| # | Sesión | Capítulo | Script |
|---|---|---|---|
| 0 | Fundamentos de R: aritmética, variables y ayuda | [capitulo00](docs/capitulos/capitulo00_fundamentos_r.md) | [sesion00](sesiones/sesion00_fundamentos_r.R) |
| 1 | Vectores y tipos de datos | [capitulo01](docs/capitulos/capitulo01_vectores_tipos.md) | [sesion01](sesiones/sesion01_vectores_tipos.R) |
| 2 | Funciones propias y familia apply | [capitulo02](docs/capitulos/capitulo02_funciones_apply.md) | [sesion02](sesiones/sesion02_funciones_apply.R) |
| 2b | Matrices | [capitulo02b](docs/capitulos/capitulo02b_matrices.md) | [sesion02b](sesiones/sesion02b_matrices.R) |
| 2c | Data Frames en base R | [capitulo02c](docs/capitulos/capitulo02c_dataframes_base.md) | [sesion02c](sesiones/sesion02c_dataframes_base.R) |
| 3 | Importación de datos y verbos de dplyr | [capitulo03](docs/capitulos/capitulo03_importacion_dplyr.md) | [sesion03](sesiones/sesion03_importacion_dplyr.R) |
| 4 | Agregación, tidyr y ggplot2 | [capitulo04](docs/capitulos/capitulo04_agregacion_tidyr_ggplot2.md) | [sesion04](sesiones/sesion04_agregacion_tidyr_ggplot2.R) |
| 5 | Proyectos reproducibles (Quarto/R Markdown) | [capitulo05](docs/capitulos/capitulo05_proyectos_reproducibles.md) | [sesion05](sesiones/sesion05_proyectos_reproducibles.R) |
| 6 | Cómputo estadístico y simulación (Monte Carlo) | [capitulo06](docs/capitulos/capitulo06_computo_simulacion.md) | [sesion06](sesiones/sesion06_computo_simulacion.R) |
| 7 | Regresión lineal (`lm`) | [capitulo07](docs/capitulos/capitulo07_regresion_lineal.md) | [sesion07](sesiones/sesion07_regresion_lineal.R) |
| 8 | Diagnóstico de supuestos y ANOVA | [capitulo08](docs/capitulos/capitulo08_diagnostico_anova.md) | [sesion08](sesiones/sesion08_diagnostico_anova.R) |
| 9 | Modelos lineales generalizados (`glm`) | [capitulo09](docs/capitulos/capitulo09_glm.md) | [sesion09](sesiones/sesion09_glm.R) |
| 10 | Validación de modelos y mini-proyecto integrador | [capitulo10](docs/capitulos/capitulo10_validacion_cierre.md) | [sesion10](sesiones/sesion10_validacion_cierre.R) |

Las sesiones 0, 2b y 2c son de fundamentos de R (aritmética/variables, matrices, data frames en base R) — puedes saltarlas si ya tienes ese terreno cubierto y avanzar directo a la sesión 1. Detalles de objetivos, evaluación y requisitos previos en [`docs/silabo.md`](docs/silabo.md).

## Cómo empezar

1. Sigue la [guía de instalación](docs/instalacion.md) si aún no tienes R y RStudio configurados.

2. Clona el repositorio:

   ```bash
   git clone https://github.com/<tu-usuario>/curso-r-cimat.git
   cd curso-r-cimat
   ```

3. Abre `curso-r-cimat.Rproj` en RStudio (o abre la carpeta en Positron/VS Code).

4. Instala las dependencias:

   ```r
   source("install.R")
   ```

5. Lee el capítulo de la sesión en `docs/capitulos/` y corre el script equivalente en `sesiones/`. Ambos usan datasets incluidos en R (`mpg`, `mtcars`, `iris`, `warpbreaks`), así que no necesitas datos externos.

## Requisitos

- R ≥ 4.2
- RStudio Desktop o Positron (recomendado, no estrictamente necesario)
- Paquetes: `tidyverse`, `broom`, `car` (ver [`install.R`](install.R))

## Mini-proyecto integrador

El curso cierra con un mini-proyecto reproducible en Quarto, descrito al final del [capítulo 10](docs/capitulos/capitulo10_validacion_cierre.md).

## Licencia

Este material está disponible bajo [CC BY 4.0](LICENSE): puedes usarlo, adaptarlo y redistribuirlo, incluso con fines comerciales, siempre que se dé el crédito correspondiente.
