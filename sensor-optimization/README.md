# Sensor Optimization

![Status](https://img.shields.io/badge/status-historical-64748b)
![R](https://img.shields.io/badge/R-simulation%20%2B%20caret-276dc3)
![Optimization](https://img.shields.io/badge/optimization-genetic%20algorithm-7c3aed)
![Domain](https://img.shields.io/badge/domain-spectral%20sensing-059669)

Historical work for simulating spectral sensor responses and exploring low-cost filter combinations for stress/control classification.

This module now gathers the full sensor-optimization lineage inside canonical `demeter`: a cleaned historical workflow, input-data notes, and imported legacy snapshots from the former `Demeter2` and `sensordevlopment` repositories.

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
| `R/simulate.R` | Safer simulation helper derived from the original `functions.R` helper. |
| `R/sensor_optimization.R` | Cleaned historical script skeleton based on the original `sensorv3.R` workflow. |
| `data/README.md` | Documents required reference/input data and expected layout. |
| `legacy/d2/` | Imported legacy snapshot of the former `Demeter2` repository. |
| `legacy/sd/` | Imported legacy snapshot of the former `sensordevlopment` repository. |

## Important limitations

This is historical research code, not a maintained package. The cleaned scripts remove some obvious runtime hazards, but the original experiments still depended on specific input folders, catalog tables, and local exploratory context.

Known required inputs:

- Filter catalog data equivalent to `FWHM.csv`.
- Range/blocking filter data equivalent to `ranges.csv`.
- Pi camera response curves, originally expected at `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv`.
- Spectral CSV archives, originally expected under `csv_archive/`.
- A `dataformat()` helper, which was referenced by the original script but is not included in the cleaned skeleton.

## Cleanup applied in the canonical workflow

The cleaned workflow avoids several obvious issues found in the original `sensorv3.R` variants:

- Removed `setwd("~/Demeter2")`.
- Removed `stopCluster(cl)` before `cl` exists.
- Replaced always-true R logic such as `filters == 2 || 3` with `filters %in% c(2, 3)`.
- Replaced global `simsize` dependency with an explicit function argument.
- Added guards for sparse, constant, and all-NA vectors in simulation.
- Documented missing inputs rather than pretending the workflow is fully runnable.

## Legacy snapshots

The imported `legacy/d2/` and `legacy/sd/` directories preserve the original repository layouts, including data tables and experiment files, so the complete code lineage now lives in one canonical repo.
