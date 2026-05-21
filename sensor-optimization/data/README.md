# Sensor Optimization Data

This directory documents the data inputs expected by the historical `Demeter2` sensor/filter optimization workflow.

The reference input files are not included in this repository. Add reproducible sample inputs here, or document where equivalent source files can be obtained.

## Expected reference files

| Original file | Purpose | Status |
|---|---|---|
| `FWHM.csv` | Optical filter catalog with price, full width at half maximum, and center wavelength. | Expected by the original workflow. |
| `ranges.csv` | Range/blocking filter catalog with min/max wavelengths, blocking intervals, and prices. | Expected by the original workflow. |
| `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv` | Pi camera spectral response curve used to convert spectra into RGB-like sensor response. | Expected by the original workflow. |
| `csv_archive/` | Spectral replicate CSV files by treatment/condition. | Expected by the original workflow. |

## Data notes

Filter prices in the original data should be treated as historical values from the time of the experiment. Do not present them as current catalog prices without verification.
