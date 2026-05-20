# Historical helper migrated from codychampion/Demeter2/functions.R.
#
# The original helper sampled from an empirical density estimate and depended on a
# global `simsize` variable. This version keeps the same intent but makes the
# sample size explicit and adds guards for sparse or degenerate input.

simulate_from_density <- function(values, n = 250, seed = NULL) {
  if (!is.null(seed)) {
    set.seed(seed)
  }

  values <- as.numeric(values)
  values <- values[is.finite(values)]

  if (length(values) == 0) {
    return(rep(NA_real_, n))
  }

  if (length(unique(values)) == 1) {
    return(rep(values[1], n))
  }

  if (length(values) < 2) {
    return(rep(mean(values, na.rm = TRUE), n))
  }

  density_estimate <- density(values)
  cumulative_density <- cumsum(density_estimate$y) / sum(density_estimate$y)

  simulated <- approx(
    x = cumulative_density,
    y = density_estimate$x,
    xout = runif(n),
    ties = "ordered"
  )$y

  simulated[is.na(simulated)] <- mean(simulated, na.rm = TRUE)
  simulated
}
