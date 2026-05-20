# Sensor Optimization Data

This directory documents the data inputs expected by the historical `Demeter2` sensor/filter optimization workflow.

The reference input files were not fully migrated through the connector because some file responses were truncated. Before final public release, copy audited versions of the original files into this directory or document where they can be obtained.

## Expected reference files

| Original file | Purpose | Migration status |
|---|---|---|
| `FWHM.csv` | Optical filter catalog with price, full width at half maximum, and center wavelength. | Reviewed in `Demeter2`; copy audited full file here before final release. |
| `ranges.csv` | Range/blocking filter catalog with min/max wavelengths, blocking intervals, and prices. | Reviewed in `Demeter2`; copy audited full file here before final release. |
| `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv` | Pi camera spectral response curve used to convert spectra into RGB-like sensor response. | Referenced by original script; not migrated yet. |
| `csv_archive/` | Spectral replicate CSV files by treatment/condition. | Referenced by original script; not migrated yet. |

## Public-release notes

The reviewed rows of `FWHM.csv` and `ranges.csv` looked like public/reference catalog-style data rather than private data. Still, run a full local file-tree audit before making this repository public.

Filter prices in the original data should be treated as historical values from the time of the experiment. Do not present them as current catalog prices without verification.
