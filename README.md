# Curso de nivelación en R — CIMAT Aguascalientes

Material de un curso intensivo de R para alumnos de nuevo ingreso a la maestría del CIMAT Aguascalientes, previo al curso de Modelación Estadística. Está pensado para estudiantes que ya saben programar en algún otro lenguaje, así que va directo a los idiomas propios de R (vectorización, tidyverse, modelación) sin detenerse en conceptos generales de programación.

**10 sesiones de 2 horas · 20 horas totales · 5 días, 2 sesiones al día.**

El temario completo está en [`docs/silabo.md`](docs/silabo.md).

## Estructura del repositorio

```
curso-r-cimat/
├── curso-r-cimat.Rproj      # abre el proyecto en RStudio/Posit
├── install.R                # instala las dependencias del curso
├── docs/
│   └── silabo.md            # temario, objetivos y evaluación
└── sesiones/
    ├── sesion01_vectores_tipos.R
    ├── sesion02_funciones_apply.R
    ├── sesion03_importacion_dplyr.R
    ├── sesion04_agregacion_tidyr_ggplot2.R
    ├── sesion05_proyectos_reproducibles.R
    ├── sesion06_computo_simulacion.R
    ├── sesion07_regresion_lineal.R
    ├── sesion08_diagnostico_anova.R
    ├── sesion09_glm.R
    └── sesion10_validacion_cierre.R
```

Cada script de `sesiones/` es autocontenido: incluye el objetivo de la sesión, ejemplos comentados y una sección de ejercicios al final.

## Temario

| # | Momento | Sesión |
|---|---|---|
| 1 | Día 1 · mañana | Vectores y tipos de datos |
| 2 | Día 1 · tarde | Funciones propias y familia apply |
| 3 | Día 2 · mañana | Importación de datos y verbos de dplyr |
| 4 | Día 2 · tarde | Agregación, tidyr y ggplot2 |
| 5 | Día 3 · mañana | Proyectos reproducibles (Quarto/R Markdown) |
| 6 | Día 3 · tarde | Cómputo estadístico y simulación (Monte Carlo) |
| 7 | Día 4 · mañana | Regresión lineal (`lm`) |
| 8 | Día 4 · tarde | Diagnóstico de supuestos y ANOVA |
| 9 | Día 5 · mañana | Modelos lineales generalizados (`glm`) |
| 10 | Día 5 · tarde | Validación de modelos y mini-proyecto integrador |

Detalles de objetivos, evaluación y requisitos previos en [`docs/silabo.md`](docs/silabo.md).

## Cómo empezar

1. Clona el repositorio:

   ```bash
   git clone https://github.com/<tu-usuario>/curso-r-cimat.git
   cd curso-r-cimat
   ```

2. Abre `curso-r-cimat.Rproj` en RStudio (o abre la carpeta en Positron/VS Code).

3. Instala las dependencias:

   ```r
   source("install.R")
   ```

4. Abre los scripts de `sesiones/` en orden. Cada uno corre de principio a fin sin necesidad de datos externos (usa datasets incluidos en R, como `mpg`, `mtcars` y `warpbreaks`).

## Requisitos

- R ≥ 4.2
- RStudio Desktop o Positron (recomendado, no estrictamente necesario)
- Paquetes: `tidyverse`, `broom`, `car` (ver [`install.R`](install.R))

## Mini-proyecto integrador

El curso cierra con un mini-proyecto reproducible en Quarto, descrito al final de [`sesiones/sesion10_validacion_cierre.R`](sesiones/sesion10_validacion_cierre.R).

## Licencia

Este material está disponible bajo [CC BY 4.0](LICENSE): puedes usarlo, adaptarlo y redistribuirlo, incluso con fines comerciales, siempre que se dé el crédito correspondiente.
