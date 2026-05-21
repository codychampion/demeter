# Sensor Optimization Data

This directory documents the data inputs expected by the historical sensor/filter optimization workflow.

## Expected reference files

| Original file | Purpose | Notes |
|---|---|---|
| `FWHM.csv` | Optical filter catalog with price, full width at half maximum, and center wavelength. | Historical reference table used by the optimization scripts. |
| `ranges.csv` | Range/blocking filter catalog with min/max wavelengths, blocking intervals, and prices. | Historical reference table used by the optimization scripts. |
| `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv` | Pi camera spectral response curve used to convert spectra into RGB-like sensor response. | Referenced by the original scripts. |
| `csv_archive/` | Spectral replicate CSV files by treatment/condition. | Referenced by the original scripts. |

Filter prices in the original data should be treated as historical values from the time of the experiment rather than as current catalog prices.
