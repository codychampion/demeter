# Demeter

![Status](https://img.shields.io/badge/status-historical-64748b)
![Postdoc Work](https://img.shields.io/badge/context-postdoc%20research-111827)
![TerraRef](https://img.shields.io/badge/data-TerraRef-059669)
![Hyperspectral](https://img.shields.io/badge/domain-hyperspectral%20phenotyping-7c3aed)
![R](https://img.shields.io/badge/R-analysis-276dc3)

Postdoc-era research code for working with TerraRef plant phenotyping data, including hyperspectral extraction, vegetation-index support utilities, and exploratory workflows for summarizing plant-associated spectral signals.

This repository is being prepared for a possible public release as part of a broader GitHub portfolio cleanup. It should be treated as historical scientific work rather than an actively maintained package until the release audit is complete.

## Scientific context

Demeter sits at the intersection of plant phenotyping, hyperspectral remote sensing, and reproducible scientific data processing. The code was developed around TerraRef data products and exploratory analysis workflows for extracting plant-relevant spectral information from large sensor datasets.

The core idea is to move from raw or semi-processed TerraRef files toward usable summaries: download targets, extract variables, define ratios and indices, isolate plant-associated pixels, and normalize spectra for downstream analysis.

## Workflow components

The original project notes describe workflow pieces for:

| Component | Purpose |
|---|---|
| TerraRef download list generation | Builds command-line download targets for TerraRef data products. |
| `ind.nc` processing | Extracts variables from index files and computes summary statistics such as standard deviation. |
| Ratio / index definitions | Maintains formal definitions for vegetation or spectral index variables. |
| Full-spectra extraction | Extracts average plant spectra using chlorophyll-informed masking around the 665 nm peak and k-means grouping. |
| Band / wavelength utilities | Converts between band or index terms and wavelengths. |

File names and locations should be verified during the public-release audit before this README is treated as final public documentation.

## Historical status

This is research code from a postdoc workflow, not a polished package. Before making this repository public, it should be audited for:

- local filesystem paths
- credentials, tokens, keys, or cloud configuration
- unpublished data or derived data products
- large generated files
- institution- or collaborator-specific notes
- scripts that assume a local machine layout
- missing citations, acknowledgements, or dataset attribution

## Public-release audit status

Initial connector-level searches did not surface obvious credential or secret hits, but the available GitHub search index appears sparse for this repository. A complete public-release decision still needs a file-tree review and local clone audit.

Recommended local checks before flipping visibility:

```bash
# file inventory
git ls-files

# common sensitive strings
grep -RInE "password|token|secret|api[_-]?key|client[_-]?secret|BEGIN .*PRIVATE|AWS_|\.env|/Users/|/home/|C:\\" .

# large files
git lfs ls-files || true
find . -type f -size +10M -print
```

## Relationship to `Demeter2`

There is also a public `codychampion/Demeter2` repository. The current cleanup question is whether `Demeter2` is a continuation, rewrite, partial mirror, or duplicate of this work.

Recommended path:

1. Audit this repository first because it has the clearer scientific context.
2. Compare file trees and overlap with `Demeter2`.
3. Choose one canonical public repo name.
4. Archive or redirect the non-canonical repo.
5. Only then make the canonical repo public and link it from the GitHub profile.

## Possible public positioning

If released publicly, this should be framed as:

> Historical postdoc research code for TerraRef hyperspectral plant phenotyping workflows.

It should not be presented as a maintained package unless the code is modernized, tested, and documented with reproducible examples.

## Citation / attribution

If this work is connected to a publication, project page, dataset, collaborator group, or postdoc institution record, add that citation here before public release.
