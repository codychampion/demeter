# Sensor Optimization

![Status](https://img.shields.io/badge/status-historical-64748b)
![R](https://img.shields.io/badge/R-simulation%20%2B%20caret-276dc3)
![Optimization](https://img.shields.io/badge/optimization-genetic%20algorithm-7c3aed)
![Domain](https://img.shields.io/badge/domain-spectral%20sensing-059669)

Historical follow-on work from `Demeter2` for simulating spectral sensor responses and exploring low-cost filter combinations for stress/control classification.

This module is now part of the canonical `demeter` repository. The imported legacy snapshots under `legacy/` preserve the original file lineage, while `R/` contains a cleaned historical skeleton for easier inspection.

## What this module does

The original `Demeter2` workflow:

1. Loads spectral replicate data by condition.
2. Simulates additional observations from empirical density estimates.
3. Merges spectra with Pi camera response curves.
4. Applies candidate optical filters from catalog/reference tables.
5. Trains classification models with `caret`.
6. Uses a genetic algorithm to search over filter/model combinations.

## Files

| Path | Purpose |
|---|---|
| `R/simulate.R` | Safer simulation helper ported from `Demeter2/functions.R`. |
| `R/sensor_optimization.R` | Cleaned historical script skeleton based on `Demeter2/sensorv3.R`. |
| `data/README.md` | Documents required reference/input data and migration status. |

## Important limitations

This is historical research code, not a maintained package. The original `Demeter2` script depended on local working directories and input folders that are preserved in the imported legacy snapshot rather than converted into a fully reproducible package.

Known required inputs:

- Filter catalog data equivalent to `FWHM.csv`.
- Range/blocking filter data equivalent to `ranges.csv`.
- Pi camera response curves, originally expected at `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv`.
- Spectral CSV archives, originally expected under `csv_archive/`.
- A `dataformat()` helper, which was referenced by the original script but was not accessible through the connector during review.

## Cleanup applied during merge

The cleaned module avoids several obvious issues found in `Demeter2/sensorv3.R`:

- Removed `setwd("~/Demeter2")`.
- Removed `stopCluster(cl)` before `cl` exists.
- Replaced always-true R logic such as `filters == 2 || 3` with `filters %in% c(2, 3)`.
- Replaced global `simsize` dependency with an explicit function argument.
- Added guards for sparse, constant, and all-NA vectors in simulation.
- Documented missing inputs rather than pretending the workflow is fully runnable.

## Research posture

This module should be read as historical exploratory research. A future reproducibility pass would add a small synthetic dataset, a dependency lockfile, and a short end-to-end example.
