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

# 1. Residuals vs Fitted -> ¿hay patrón? (viola linealidad/homocedasticidad)
# 2. Q-Q plot -> ¿residuos se ven normales?
# 3. Scale-Location -> homocedasticidad
# 4. Residuals vs Leverage -> observaciones influyentes (distancia de Cook)

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
