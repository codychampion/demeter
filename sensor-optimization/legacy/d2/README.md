# Demeter2

![Status](https://img.shields.io/badge/status-historical-64748b)
![Historical](https://img.shields.io/badge/project-historical-64748b)
![Geospatial](https://img.shields.io/badge/domain-geospatial%20analysis-2563eb)
![TerraRef](https://img.shields.io/badge/data-TerraRef-059669)

Historical research code related to TerraRef / plant phenotyping workflows.

This directory preserves the original `Demeter2` repository layout as a historical snapshot within the consolidated `demeter` codebase.

## Current status

Treat this material as historical project context rather than as an actively maintained package.

## Related work

The broader Demeter work includes TerraRef / hyperspectral extraction utilities, including:

- generating TerraRef download lists
- extracting and summarizing variables from `ind.nc` files
- maintaining ratio/index definitions
- extracting plant-associated spectra using chlorophyll-informed masking
- converting between wavelength and band/index terms

Those notes suggest the broader project sits at the intersection of plant phenotyping, hyperspectral data processing, and geospatial / remote-sensing analysis.

## Relationship to the canonical workflow

For the cleaned historical workflow, start with:

- `../../R/sensor_optimization.R`
- `../../R/simulate.R`
- `../../data/README.md`
