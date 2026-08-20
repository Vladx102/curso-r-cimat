# =============================================================================
# Sesión 8 — Día 4 · tarde — Diagnóstico de supuestos y ANOVA
# Curso de nivelación en R — CIMAT Aguascalientes
# =============================================================================
#
# Objetivo de la sesión (2h):
#   Trabajar con interacciones, diagnosticar los supuestos de un modelo
#   lineal y comparar modelos anidados con ANOVA.

library(tidyverse)
library(broom)

datos <- as_tibble(mpg)
modelo_multi <- lm(hwy ~ displ + cyl + class, data = datos)

# -----------------------------------------------------------------------------
# 1. Interacciones
# -----------------------------------------------------------------------------

modelo_interaccion <- lm(hwy ~ displ * drv, data = datos)
summary(modelo_interaccion)

ggplot(datos, aes(displ, hwy, color = drv)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Interacción displ:drv") +
  theme_minimal()

# -----------------------------------------------------------------------------
# 2. Diagnóstico de supuestos
# -----------------------------------------------------------------------------
# Supuestos clásicos de lm(): linealidad, homocedasticidad, normalidad de
# residuos, independencia, ausencia de multicolinealidad severa.

par(mfrow = c(2, 2))
plot(modelo_multi)      # 4 gráficos de diagnóstico clásicos de R
par(mfrow = c(1, 1))

# 1. Residuals vs Fitted  2. Q-Q plot  3. Scale-Location  4. Residuals vs Leverage

# Multicolinealidad: VIF (Variance Inflation Factor)
# install.packages("car")
car::vif(modelo_multi)     # VIF > 5-10 sugiere colinealidad problemática

# Residuos "aumentados" con broom, útiles para graficar con ggplot
aug <- augment(modelo_multi)
ggplot(aug, aes(.fitted, .resid)) +
  geom_point(alpha = 0.4) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  labs(title = "Residuos vs. valores ajustados") +
  theme_minimal()

# -----------------------------------------------------------------------------
# 3. ANOVA y comparación de modelos anidados
# -----------------------------------------------------------------------------

modelo_simple <- lm(hwy ~ displ, data = datos)
anova(modelo_simple, modelo_multi)   # ¿mejora significativamente el modelo
                                       # más grande respecto al más chico?

# ANOVA de un factor (equivalente a comparar medias entre grupos)
modelo_anova <- lm(hwy ~ class, data = datos)
anova(modelo_anova)

# =============================================================================
# EJERCICIOS
# =============================================================================

# 1. Usando augment(), identifica las 3 observaciones con mayor residuo
#    absoluto del modelo_multi. ¿Qué tienen en común?

# 2. (Reto) Ajusta dos modelos anidados: uno sin interacción
#    (hwy ~ displ + drv) y otro con interacción (hwy ~ displ * drv).
#    Compáralos con anova() y decide, con base en el p-value, si la
#    interacción aporta información significativa.

# =============================================================================
# EJEMPLO: diagnóstico completo y decisión informada
# =============================================================================

aug_multi <- augment(modelo_multi)

# Normalidad de los residuos: complementa el Q-Q plot con una prueba formal
# (shapiro.test(), de la sesión 6) -- H0: los residuos son normales
shapiro.test(aug_multi$.resid)

# Observaciones influyentes: distancia de Cook > 4/n es una regla práctica
# común (no es un umbral mágico, pero sirve como primer filtro)
umbral_cook <- 4 / nrow(aug_multi)
idx_influyentes <- which(aug_multi$.cooksd > umbral_cook)
length(idx_influyentes)
aug_multi[idx_influyentes, c("hwy", ".fitted", ".resid", ".cooksd")]

# ¿Cambian mucho los coeficientes si quitamos esas observaciones?
modelo_sin_influyentes <- lm(hwy ~ displ + cyl + class, data = datos[-idx_influyentes, ])

bind_rows(
  tidy(modelo_multi) %>% mutate(modelo = "con todas"),
  tidy(modelo_sin_influyentes) %>% mutate(modelo = "sin influyentes")
) %>%
  select(modelo, term, estimate) %>%
  pivot_wider(names_from = modelo, values_from = estimate)

# 3. Ajusta modelo_simple <- lm(hwy ~ displ, data = datos), corre
#    augment(modelo_simple) y grafica un histograma de sus residuos
#    (.resid) con ggplot2. Complementa con shapiro.test() sobre esos
#    residuos. ¿Coinciden tu impresión visual y la prueba formal?

# 4. (Reto) Usando modelo_interaccion (definido arriba), calcula
#    augment(modelo_interaccion), identifica las observaciones con
#    distancia de Cook mayor a 4/n, y ajusta un modelo sin esas
#    observaciones. ¿Cambian mucho los coeficientes?
