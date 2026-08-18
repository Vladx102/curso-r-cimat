# Guía de preparación previa: instalación de R y RStudio

Esta guía es material de preparación, **no una sesión del curso**: complétala antes de la sesión 0 / sesión 1 para llegar con el entorno listo. El sílabo ([`silabo.md`](silabo.md)) ya la marca como requisito previo.

## Introducción

[R](https://www.r-project.org/) es un lenguaje de programación diseñado específicamente para cómputo estadístico y visualización de datos. [RStudio](https://posit.co/download/rstudio-desktop/) (ahora parte de Posit) es un IDE (entorno de desarrollo integrado) que hace mucho más cómodo trabajar con R: editor de código con resaltado de sintaxis, consola integrada, explorador de variables, gestor de paquetes y visor de gráficos, todo en una sola ventana.

R y RStudio son **dos programas distintos**: R es el motor que ejecuta el código; RStudio es la interfaz que lo hace agradable de usar. Necesitas instalar ambos, en ese orden.

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
