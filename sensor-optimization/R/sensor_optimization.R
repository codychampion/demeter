# Historical sensor/filter optimization workflow migrated from codychampion/Demeter2/sensorv3.R.
#
# This is a cleaned release skeleton, not a fully reproducible pipeline yet. It
# preserves the original workflow shape while removing hard-coded working
# directories and fixing several obvious runtime issues.

suppressPackageStartupMessages({
  library(dplyr)
  library(caret)
  library(GA)
})

`%||%` <- function(lhs, rhs) {
  if (is.null(lhs)) rhs else lhs
}

load_simulation_helper <- function() {
  candidate_paths <- c(
    "sensor-optimization/R/simulate.R",
    file.path(getwd(), "sensor-optimization", "R", "simulate.R"),
    file.path(dirname(sys.frame(1)$ofile %||% ""), "simulate.R")
  )

  helper_path <- candidate_paths[file.exists(candidate_paths)][1]
  if (is.na(helper_path)) {
    stop("Could not find simulate.R. Run from the repository root or source simulate.R manually.")
  }

  source(helper_path)
}

load_simulation_helper()

clamp_bounds <- function(lower, upper, min_wave = 401, max_wave = 1022) {
  lower <- max(lower, min_wave, na.rm = TRUE)
  upper <- min(upper, max_wave, na.rm = TRUE)

  if (!is.finite(lower) || !is.finite(upper) || lower > upper) {
    stop("Invalid wavelength bounds after clamping.")
  }

  list(lower = lower, upper = upper)
}

summarise_band <- function(spectral_data, lowerbound, upperbound) {
  spectral_data %>%
    dplyr::group_by(con, rep) %>%
    dplyr::filter(wave > lowerbound & wave < upperbound) %>%
    dplyr::summarise(
      filter_avg_r = sum(red, na.rm = TRUE),
      filter_avg_b = sum(blue, na.rm = TRUE),
      filter_avg_g = sum(green, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    as.data.frame()
}

filter_response <- function(filternumber, spectral_data, fwhm, ranges) {
  fwhm_range <- nrow(fwhm)
  filternumber <- round(filternumber)

  if (filternumber < 1 || filternumber > fwhm_range + nrow(ranges)) {
    stop("filternumber is outside the filter catalog range.")
  }

  if (filternumber <= fwhm_range) {
    filterdata <- fwhm[filternumber, ]
    half_width <- filterdata$nm.FWHM / 2
    bounds <- clamp_bounds(
      lower = filterdata$nm.CWL - half_width,
      upper = filterdata$nm.CWL + half_width
    )

    return(list(
      data = summarise_band(spectral_data, bounds$lower, bounds$upper),
      price = filterdata$price
    ))
  }

  filterdata <- ranges[filternumber - fwhm_range, ]
  price <- filterdata$price

  if (!is.na(filterdata$nm.min)) {
    bounds <- clamp_bounds(filterdata$nm.min, filterdata$nm.max)
    return(list(
      data = summarise_band(spectral_data, bounds$lower, bounds$upper),
      price = price
    ))
  }

  low_bounds <- clamp_bounds(401, filterdata$block.min)
  high_bounds <- clamp_bounds(filterdata$block.max, 1022)

  outlow <- summarise_band(spectral_data, low_bounds$lower, low_bounds$upper)
  outhigh <- summarise_band(spectral_data, high_bounds$lower, high_bounds$upper)

  colnames(outhigh) <- c("con", "rep", "highr", "highb", "highg")
  colnames(outlow) <- c("con", "rep", "lowr", "lowb", "lowg")

  outtmp <- merge(outhigh, outlow, by = c("con", "rep"), all = TRUE)
  out <- data.frame(con = outtmp$con, rep = outtmp$rep)
  out$filter_avg_r <- rowSums(outtmp[, c("highr", "lowr")], na.rm = TRUE)
  out$filter_avg_b <- rowSums(outtmp[, c("highb", "lowb")], na.rm = TRUE)
  out$filter_avg_g <- rowSums(outtmp[, c("highg", "lowg")], na.rm = TRUE)

  list(data = out, price = price)
}

evaluate_filter_set <- function(filternumbers,
                                model_index,
                                spectral_data,
                                fwhm,
                                ranges,
                                models = c("rf", "glm", "lm", "adaboost", "avNNet", "svm", "C5.0")) {
  filternumbers <- round(filternumbers)
  model_index <- round(model_index)

  if (model_index < 1 || model_index > length(models)) {
    stop("model_index is outside the supported model list.")
  }

  responses <- lapply(filternumbers, filter_response, spectral_data = spectral_data, fwhm = fwhm, ranges = ranges)
  prices <- vapply(responses, function(x) x$price, numeric(1))

  merged <- responses[[1]]$data
  if (length(responses) > 1) {
    for (i in 2:length(responses)) {
      merged <- merge(merged, responses[[i]]$data, by = c("con", "rep"), suffixes = c("", paste0("_", i)))
    }
  }

  merged$rep <- NULL

  control <- trainControl(method = "repeatedcv", number = 10, repeats = 5)
  start <- proc.time()

  fit <- tryCatch(
    caret::train(
      con ~ .,
      data = merged,
      method = models[model_index],
      trControl = control
    ),
    error = function(e) e
  )

  elapsed <- proc.time() - start
  if (inherits(fit, "error")) {
    return(0)
  }

  results <- as.data.frame(fit$results)
  accuracy <- if ("Accuracy" %in% names(results)) max(results$Accuracy, na.rm = TRUE) else 0
  penalty <- 0.25 * max(length(filternumbers) - 1, 0)
  cost_penalty <- 0.001 * sum(prices, na.rm = TRUE)
  time_penalty <- 0.000001 * as.numeric(elapsed[3])

  max(accuracy - penalty - cost_penalty - time_penalty, 0)
}

# Historical entry point. Requires migrated input data; see sensor-optimization/data/README.md.
run_sensor_optimization <- function(spectral_data,
                                    fwhm,
                                    ranges,
                                    max_filters = 3,
                                    max_model_index = 7,
                                    pop_size = 100,
                                    maxiter = 25) {
  GA::ga(
    type = "real-valued",
    fitness = function(x) {
      filter_count <- min(max(round(x[4]), 1), max_filters)
      filter_ids <- x[seq_len(filter_count)]
      evaluate_filter_set(
        filternumbers = filter_ids,
        model_index = x[5],
        spectral_data = spectral_data,
        fwhm = fwhm,
        ranges = ranges
      )
    },
    min = c(1, 1, 1, 1, 1),
    max = c(nrow(fwhm) + nrow(ranges), nrow(fwhm) + nrow(ranges), nrow(fwhm) + nrow(ranges), max_filters, max_model_index),
    popSize = pop_size,
    maxiter = maxiter,
    run = maxiter,
    monitor = plot
  )
}
