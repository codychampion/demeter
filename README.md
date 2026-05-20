# Demeter

![Status](https://img.shields.io/badge/status-historical-64748b)
![Postdoc Work](https://img.shields.io/badge/context-postdoc%20research-111827)
![TerraRef](https://img.shields.io/badge/data-TerraRef-059669)
![Hyperspectral](https://img.shields.io/badge/domain-hyperspectral%20phenotyping-7c3aed)
![R](https://img.shields.io/badge/R-analysis-276dc3)

Historical postdoc research code for TerraRef hyperspectral plant phenotyping and follow-on spectral sensor/filter optimization experiments.

Demeter combines two related threads of work:

1. **TerraRef / hyperspectral processing** — download manifests, NetCDF/index processing, vegetation-index metadata, and exploratory plant-associated spectral extraction workflows.
2. **Sensor optimization** — follow-on `Demeter2` work for simulating spectra, applying low-cost optical filters, and optimizing filter/model combinations.

This repository is being prepared for public release as scientific portfolio material. It should be treated as historical research code rather than an actively maintained package.

## Scientific context

Demeter sits at the intersection of plant phenotyping, hyperspectral remote sensing, and reproducible scientific data processing. The code was developed around TerraRef data products and exploratory analysis workflows for extracting plant-relevant spectral information from large sensor datasets.

The core idea is to move from raw or semi-processed TerraRef files toward usable summaries: download targets, extract variables, define ratios and indices, isolate plant-associated pixels, normalize spectra, and explore whether cheaper sensor/filter combinations can preserve useful classification signal.

## Repository structure

| Area | Purpose |
|---|---|
| TerraRef processing files | Historical scripts and manifests for working with TerraRef VNIR / index data products. |
| Vegetation-index metadata | Reference metadata, formulas, citations, and variable definitions for spectral indices. |
| `sensor-optimization/` | Cleaned module migrated from `Demeter2` for spectral simulation and filter/model optimization. |
| `PUBLIC_RELEASE_NOTES.md` | Release posture, limitations, and pre-publication checklist. |

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

The `sensor-optimization/` directory preserves the useful follow-on work from public `Demeter2` while cleaning the release-blocking issues found during code review.

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

This is postdoc research code, not a polished package. Before making this repository public, run a local audit for:

- local filesystem paths
- credentials, tokens, keys, or cloud configuration
- unpublished data or derived data products
- large generated files
- institution- or collaborator-specific notes
- scripts that assume a local machine layout
- missing citations, acknowledgements, or dataset attribution

## Public-release audit status

Connector-level searches did not surface obvious credential or secret hits in the reviewed material, and the data files inspected looked like public/reference data or generated public TerraRef manifests. However, the connector search index was sparse and some large file responses were truncated, so a complete public-release decision still needs a local clone audit.

Recommended local checks before flipping visibility:

```bash
# file inventory
git ls-files

# large files
git lfs ls-files || true
find . -type f -size +10M -print
```

Also search locally for sensitive strings, local machine paths, and collaborator/institution-specific notes before making the repo public.

## Relationship to `Demeter2`

`Demeter2` should now be treated as the source archive for the sensor optimization work that is being folded into this canonical repository.

Recommended next step after this branch is reviewed:

1. Copy any audited large/reference input files that could not be migrated through the connector.
2. Make this repository public once the local audit passes.
3. Update `Demeter2` to redirect here.
4. Archive `Demeter2` unless there is a reason to keep it as a separate historical companion repo.

## Possible public positioning

> Historical postdoc research code for TerraRef hyperspectral plant phenotyping and low-cost spectral sensor/filter optimization experiments.

It should not be presented as a maintained package unless the code is modernized, tested, and documented with reproducible examples.

## Citation / attribution

If this work is connected to a publication, project page, dataset, collaborator group, or postdoc institution record, add that citation here before public release.
