# Demeter

![Status](https://img.shields.io/badge/status-historical-64748b)
![Postdoc Work](https://img.shields.io/badge/context-postdoc%20research-111827)
![TerraRef](https://img.shields.io/badge/data-TerraRef-059669)
![Hyperspectral](https://img.shields.io/badge/domain-hyperspectral%20phenotyping-7c3aed)
![R](https://img.shields.io/badge/R-analysis-276dc3)

Historical postdoc research code for TerraRef hyperspectral plant phenotyping and follow-on spectral sensor/filter optimization experiments.

Demeter combines two related threads of work:

1. **TerraRef / hyperspectral processing** - download manifests, NetCDF/index processing, vegetation-index metadata, and exploratory plant-associated spectral extraction workflows.
2. **Sensor optimization** - follow-on `Demeter2` work for simulating spectra, applying low-cost optical filters, and optimizing filter/model combinations.

This repository is historical research code rather than an actively maintained package.

## Scientific context

Demeter sits at the intersection of plant phenotyping, hyperspectral remote sensing, and reproducible scientific data processing. The code was developed around TerraRef data products and exploratory analysis workflows for extracting plant-relevant spectral information from large sensor datasets.

The core idea is to move from raw or semi-processed TerraRef files toward usable summaries: download targets, extract variables, define ratios and indices, isolate plant-associated pixels, normalize spectra, and explore whether cheaper sensor/filter combinations can preserve useful classification signal.

## Repository structure

| Area | Purpose |
|---|---|
| TerraRef processing files | Historical scripts and manifests for working with TerraRef VNIR / index data products. |
| Vegetation-index metadata | Reference metadata, formulas, citations, and variable definitions for spectral indices. |
| `sensor-optimization/` | Cleaned module migrated from `Demeter2` for spectral simulation and filter/model optimization. |

## Workflow components

The original project notes describe workflow pieces for:

| Component | Purpose |
|---|---|
| TerraRef download list generation | Builds command-line download targets for TerraRef data products. |
| `ind.nc` processing | Extracts variables from index files and computes summary statistics such as standard deviation. |
| Ratio / index definitions | Maintains formal definitions for vegetation or spectral index variables. |
| Full-spectra extraction | Extracts average plant spectra using chlorophyll-informed masking around the 665 nm peak and k-means grouping. |
| Band / wavelength utilities | Converts between band or index terms and wavelengths. |
| Sensor/filter optimization | Simulates spectral sensor response and searches for filter/model combinations that separate control/stress conditions. |

## Sensor optimization module

The `sensor-optimization/` directory preserves useful follow-on work from `Demeter2` while cleaning obvious runtime and reproducibility issues in the historical scripts.

Notable cleanup:

- Removed hard-coded `setwd("~/Demeter2")` assumptions.
- Removed `stopCluster(cl)` before cluster creation.
- Replaced always-true R conditionals such as `filters == 2 || 3`.
- Replaced scalar `sum()` behavior with row-wise aggregation where filter bands are recombined.
- Made simulation sample size explicit instead of relying on global `simsize`.
- Added guards for sparse, constant, and all-NA simulation inputs.
- Documented missing data dependencies rather than pretending the historical workflow is fully runnable.

See [`sensor-optimization/README.md`](sensor-optimization/README.md).

## Historical status

This is postdoc research code, not a polished package. Some scripts still reflect their original exploratory context, including generated manifests, rendered notebooks, and data-processing assumptions from the TerraRef workflow.

## Relationship to `Demeter2`

`Demeter2` is the earlier companion repository for the sensor optimization work now represented in `sensor-optimization/`.

## Positioning

> Historical postdoc research code for TerraRef hyperspectral plant phenotyping and low-cost spectral sensor/filter optimization experiments.

It should not be presented as a maintained package unless the code is modernized, tested, and documented with reproducible examples.

## Citation / attribution

If this work is connected to a publication, project page, dataset, collaborator group, or postdoc institution record, add that citation here.
