# Public Release Notes

Demeter is historical postdoc research code. The goal of this cleanup is to make the repository understandable and safe to release, not to present it as a maintained package.

## Release posture

This repository should be described as:

> Historical postdoc research code for TerraRef hyperspectral plant phenotyping and follow-on spectral sensor/filter optimization experiments.

## Combined structure

The combined release keeps two related but distinct threads together:

| Area | Purpose |
|---|---|
| TerraRef processing | Download manifests, NetCDF/index processing, vegetation-index metadata, and hyperspectral extraction workflows. |
| Sensor optimization | Follow-on `Demeter2` work for simulating spectra, applying low-cost optical filters, and optimizing filter/model combinations. |

## What was cleaned

- Added a stronger scientific README.
- Added `sensor-optimization/` to preserve the useful `Demeter2` workflow in the canonical repo.
- Removed hard-coded working-directory assumptions from the cleaned sensor optimization skeleton.
- Replaced global simulation state with explicit function arguments.
- Fixed obvious R logic issues in the cleaned skeleton, including always-true filter-count conditionals and row-wise filter aggregation.
- Documented required input data that still needs manual migration.

## What is still historical / incomplete

- Some original scripts may still assume local file layouts.
- Large or generated manifests should be treated as historical artifacts.
- The combined `sensor-optimization/` module is not fully reproducible until input data and a `dataformat()` equivalent are migrated.
- No dependency lockfile is present yet.
- No automated tests are present yet.

## Before making public

Run a local clone audit for:

- credentials or private tokens
- local machine paths
- large generated files
- unpublished or collaborator-sensitive data
- missing dataset/project attribution
- missing publication or institutional citations

## Recommended next pass

1. Copy audited `FWHM.csv` and `ranges.csv` into `sensor-optimization/data/`.
2. Add a small synthetic example dataset.
3. Add a short reproducible example that runs without TerraRef downloads.
4. Add citations and acknowledgements for TerraRef, the postdoc context, and any collaborators/publications.
5. Decide whether to archive `Demeter2` with a redirect back to this repository.
