# Custom MATLAB Colour Selector

This repository contains MATLAB scripts for quickly selecting custom colours and colourmaps for MATLAB.

Created by En-Chi Lee, 2024.
Last updated Jun 6, 2024.

## Usage

Make sure MATLAB has access to the `colours` and `colourspace-transformation` folders. Use the `addpath` function to add the folders to the MATLAB path.

### Create a RGB colour array

Use the `keynotecolour` or `kc` function to create an RGB colour array.

```matlab
colour1 = kc('blue', 2);
colour2 = kc('b2');
```

### create a colourmap

Use the `keynotecolourmap` or `kcmap` function to create a colourmap.

```matlab
colourMap = kcmap('seismic', 16);
```

The colourmaps are by default interpolated in the Oklab colour space.
