# Demeter

![Status](https://img.shields.io/badge/status-historical-64748b)
![Postdoc Work](https://img.shields.io/badge/context-postdoc%20research-111827)
![TerraRef](https://img.shields.io/badge/data-TerraRef-059669)
![Hyperspectral](https://img.shields.io/badge/domain-hyperspectral%20phenotyping-7c3aed)
![R](https://img.shields.io/badge/R-analysis-276dc3)

Historical postdoc research code for TerraRef hyperspectral plant phenotyping and spectral sensor/filter optimization experiments.

Demeter combines two related threads of work:

1. **TerraRef / hyperspectral processing** - download manifests, NetCDF/index processing, vegetation-index metadata, and exploratory plant-associated spectral extraction workflows.
2. **Sensor optimization** - follow-on `Demeter2` work for simulating spectra, applying low-cost optical filters, and optimizing filter/model combinations.

This repository is the canonical home for the full Demeter research arc. It includes both a cleaned sensor-optimization module and imported legacy snapshots from the earlier `Demeter2` and `sensordevlopment` repositories.

## Scientific context

Demeter sits at the intersection of plant phenotyping, hyperspectral remote sensing, and reproducible scientific data processing. The code was developed around TerraRef data products and exploratory analysis workflows for extracting plant-relevant spectral information from large sensor datasets.

The core idea is to move from raw or semi-processed TerraRef files toward usable summaries: download targets, extract variables, define ratios and indices, isolate plant-associated pixels, normalize spectra, and explore whether cheaper sensor/filter combinations can preserve useful classification signal.

## Repository structure

| Area | Purpose |
|---|---|
| `Terraref/` | Historical scripts and manifests for working with TerraRef VNIR and index data products. |
| Vegetation-index metadata | Reference metadata, formulas, citations, and variable definitions for spectral indices. |
| `sensor-optimization/R/` | Cleaned historical sensor-optimization workflow and simulation helper. |
| `sensor-optimization/data/` | Notes on required reference inputs and expected data layout. |
| `sensor-optimization/legacy/d2/` | Full imported snapshot of the former `Demeter2` repository. |
| `sensor-optimization/legacy/sd/` | Full imported snapshot of the former `sensordevlopment` repository. |
| `DoseDependence/` | Additional historical analysis artifacts from the same research period. |

## Sensor optimization

The `sensor-optimization/` directory now holds the complete lineage of the sensor/filter work in one place:

- a cleaned historical workflow in `R/`
- documentation of required inputs in `data/`
- imported legacy snapshots under `legacy/`

See [`sensor-optimization/README.md`](sensor-optimization/README.md).

## Historical status

This is postdoc research code, not a polished package. Some scripts still reflect their original exploratory context, including generated manifests, rendered notebooks, and data-processing assumptions from the TerraRef workflow.

## Citation / attribution

If this work is connected to a publication, project page, dataset, collaborator group, or institution record, add that citation here.
