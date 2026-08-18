# Guía de preparación previa: instalación de R y RStudio

Esta guía es material de preparación, **no una sesión del curso**: complétala antes de la sesión 0 / sesión 1 para llegar con el entorno listo. El sílabo ([`silabo.md`](silabo.md)) ya la marca como requisito previo.

## Introducción

[R](https://www.r-project.org/) es un lenguaje de programación diseñado específicamente para cómputo estadístico y visualización de datos. [RStudio](https://posit.co/download/rstudio-desktop/) (ahora parte de Posit) es un IDE (entorno de desarrollo integrado) que hace mucho más cómodo trabajar con R: editor de código con resaltado de sintaxis, consola integrada, explorador de variables, gestor de paquetes y visor de gráficos, todo en una sola ventana.

R y RStudio son **dos programas distintos**: R es el motor que ejecuta el código; RStudio es la interfaz que lo hace agradable de usar. Necesitas instalar ambos, en ese orden.

### Un poco de historia

R nació en 1993 en el Departamento de Estadística de la Universidad de Auckland, Nueva Zelanda, como un proyecto de los profesores **Ross Ihaka** y **Robert Gentleman** para enseñar estadística introductoria. El nombre "R" tiene doble origen: es un guiño al lenguaje que lo inspiró, **S** (desarrollado en los Laboratorios Bell en los años 70, y del cual R heredó gran parte de su sintaxis), y a la vez la inicial compartida por los nombres de sus creadores, Ross y Robert.

Unos años más tarde, en 1995, R se liberó bajo la licencia GNU GPL como software libre, lo que permitió que cualquier persona pudiera revisar, modificar y redistribuir su código fuente. En 1997 se formó el **R Core Team** (el grupo que mantiene el lenguaje hasta hoy) y se creó **CRAN** (*Comprehensive R Archive Network*), el repositorio central de paquetes de R que sigue en uso. La versión 1.0 se publicó en el año 2000, y en 2003 se fundó la **R Foundation for Statistical Computing** para darle soporte institucional al proyecto.

Desde entonces, R pasó de ser una herramienta académica de nicho a un estándar de facto en estadística aplicada, con un ecosistema que incluye el [tidyverse](https://www.tidyverse.org/) (el conjunto de paquetes que usamos en buena parte de este curso), RStudio/Posit como entorno de desarrollo, y herramientas de reportes reproducibles como R Markdown y Quarto.

### ¿Por qué R? Su utilidad hoy

A diferencia de un lenguaje de propósito general, R se diseñó desde el inicio *para hacer estadística* — eso se nota en detalles como que los vectores y las pruebas de hipótesis son ciudadanos de primera clase del lenguaje, no algo que hay que añadir con una librería externa. Algunas razones por las que sigue siendo relevante:

- **El ecosistema de paquetes más grande del mundo para estadística.** CRAN aloja miles de paquetes revisados por pares para prácticamente cualquier técnica estadística que exista, desde modelos lineales hasta series de tiempo, análisis espacial o supervivencia.
- **Estándar en investigación académica y bioestadística.** La mayoría de los artículos científicos con análisis estadístico reportan haber usado R; el proyecto [Bioconductor](https://www.bioconductor.org/) lo convirtió también en el estándar de facto en genómica y bioinformática.
- **Visualización de datos de calidad de publicación.** ggplot2 (parte del tidyverse) es, para muchos, el estándar de facto para producir gráficos estadísticos claros y reproducibles.
- **Reproducibilidad integrada.** R Markdown y Quarto permiten combinar código, resultados y texto en un solo documento que se regenera automáticamente — exactamente el flujo de trabajo que vas a practicar en la [sesión 5](capitulos/capitulo05_proyectos_reproducibles.md) de este curso.
- **Uso en la industria además de la academia.** Bancos, farmacéuticas, aseguradoras y agencias de estadística oficial (incluido el INEGI en México) usan R para modelación estadística, junto con Python como las dos herramientas más comunes en ciencia de datos.

Para el curso de Modelación Estadística que sigue a este, este último punto es la razón práctica: buena parte de la literatura y las herramientas de modelación estadística clásica (regresión, ANOVA, GLM, series de tiempo) siguen documentándose primero — o únicamente — en R.

## Instalación de R

1. Ve a [cran.r-project.org](https://cran.r-project.org/).
2. Elige tu sistema operativo (Windows, macOS o Linux).
3. **Windows:** haz clic en "base" y descarga el instalador (`R-4.x.x-win.exe`). Ejecútalo con las opciones por default.
4. **macOS:** descarga el `.pkg` correspondiente a tu chip (Apple Silicon o Intel) e instálalo como cualquier aplicación de Mac.
5. **Linux:** usa el gestor de paquetes de tu distribución (ej. `sudo apt install r-base` en Ubuntu/Debian) o sigue las instrucciones específicas de CRAN para tu distribución.

Verifica la instalación abriendo una terminal y escribiendo `R --version`, o simplemente abriendo la aplicación "R" que se instaló.

## Instalación de RStudio

1. Ve a [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/).
2. Descarga la versión gratuita ("RStudio Desktop", open source) para tu sistema operativo.
3. Instálala como cualquier otra aplicación. RStudio detecta automáticamente la instalación de R que hiciste en el paso anterior — no necesitas configurar nada adicional.

> **Alternativa:** [Positron](https://positron.posit.co/) es un IDE más nuevo de Posit (basado en VS Code) que también soporta R. Cualquiera de los dos funciona para este curso; las instrucciones aquí asumen RStudio por ser el más extendido.

## Tour de la interfaz de RStudio

Al abrir RStudio por primera vez verás la ventana dividida en paneles (el layout exacto puede variar un poco según la versión):

- **Consola (Console)** — donde se ejecuta el código línea por línea y se ven los resultados. Es el equivalente al intérprete interactivo de Python o Node.
- **Editor de scripts (Source)** — donde escribes y guardas archivos `.R`. Se abre automáticamente al crear o abrir un script; si no lo ves, es porque no tienes ningún archivo abierto.
- **Entorno (Environment)** — lista las variables, funciones y datos que existen en tu sesión actual. Útil para ver rápidamente qué objetos tienes cargados y su contenido.
- **Archivos / Gráficos / Paquetes / Ayuda (Files / Plots / Packages / Help)** — un panel con pestañas: navegador de archivos, visor de gráficos generados, gestor de paquetes instalados, y el visor de documentación de funciones (`?funcion`).

Atajos que vas a usar todo el tiempo:

| Atajo (Windows/Linux) | Atajo (Mac) | Acción |
|---|---|---|
| `Ctrl + Enter` | `Cmd + Enter` | Ejecutar la línea actual (o la selección) |
| `Ctrl + Shift + N` | `Cmd + Shift + N` | Nuevo script |
| `Ctrl + S` | `Cmd + S` | Guardar el script |
| `Ctrl + L` | `Cmd + L` | Limpiar la consola |
| `Ctrl + Shift + M` | `Cmd + Shift + M` | Insertar el pipe `%>%` |

## Crear el proyecto del curso

En vez de abrir archivos sueltos, usa el proyecto de este repositorio:

1. Clona o descarga este repositorio (ver instrucciones en el [README](../README.md)).
2. En RStudio: `File → Open Project...` y selecciona `curso-r-cimat.Rproj`.
3. En la consola, corre `source("install.R")` para instalar los paquetes necesarios.

Con eso, ya tienes todo listo para la [sesión 0](capitulos/capitulo00_fundamentos_r.md).
