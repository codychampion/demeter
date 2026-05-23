# Sensor Optimization Data

This directory documents the data inputs expected by the historical `Demeter2` sensor/filter optimization workflow.

The original reference input files are preserved in the imported legacy snapshots. This directory documents the expected inputs for readers who want to understand or reconstruct the workflow.

## Expected reference files

| Original file | Purpose | Migration status |
|---|---|---|
| `FWHM.csv` | Optical filter catalog with price, full width at half maximum, and center wavelength. | Preserved in legacy snapshots. |
| `ranges.csv` | Range/blocking filter catalog with min/max wavelengths, blocking intervals, and prices. | Preserved in legacy snapshots. |
| `pi-camera-response-curves-master/Sony_IMX219_spectral_response.csv` | Pi camera spectral response curve used to convert spectra into RGB-like sensor response. | Preserved in legacy snapshots where available. |
| `csv_archive/` | Spectral replicate CSV files by treatment/condition. | Preserved in legacy snapshots where available. |

## Notes

The reviewed rows of `FWHM.csv` and `ranges.csv` looked like public/reference catalog-style data rather than private data. Still, run a full local file-tree audit before making this repository public.

Filter prices in the original data should be treated as historical values from the time of the experiment. Do not present them as current catalog prices without verification.
