# LACE — Limbless Animal traCkEr

[![CI](https://github.com/zerotonin/LACE/actions/workflows/ci.yml/badge.svg)](https://github.com/zerotonin/LACE/actions/workflows/ci.yml)
[![MATLAB R2021a+](https://img.shields.io/badge/MATLAB-R2021a%2B-orange.svg)](https://www.mathworks.com/)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![DOI](https://img.shields.io/badge/DOI-10.3389%2Ffnbeh.2022.819146-blue.svg)](https://doi.org/10.3389/fnbeh.2022.819146)

**A markerless pose estimator applicable to limbless animals.**

The analysis of kinematics, locomotion, and spatial tasks relies on the
accurate detection of animal position and pose. Most available trackers
represent animals as single points (no pose) or rely on markers —
physical (paint, stickers, beads) or *in silico* (joints, limbs, colour
patterns) — to build a skeletal representation. Markers often cannot be
used on small animals, on animals lacking prominent body structures, or
in environments (e.g. aquatic) that detach them.

LACE builds the pose of an animal **de novo from its contour**: it
detects the contour, derives the body mid-line, and constructs a
pseudo-skeleton of vertices and edges. Applied to larval *Drosophila
melanogaster* and adult zebrafish, LACE quantifies, for example, genetic
alterations of peristaltic movements and sex-specific locomotion
patterns associated with different body shapes — even in animals without
limbs.

## Related trackers

* [idtracker.ai](https://www.idtracker.es/)
* [nematode trackers](http://www.wormbook.org)
* [TRex](https://elifesciences.org/articles/64000)
* [ivTools](https://opensource.cit-ec.de/projects/ivtools)

## Successor projects

LACE is the original MATLAB implementation. The method has since been
ported to Python and is actively maintained there:

* **[pyLACE](https://github.com/zerotonin/pyLACE)** — Python port of the
  LACE tracker.
* **[pyLACEpostHoc](https://github.com/zerotonin/pyLACEpostHoc)** —
  database, post-hoc analysis, and plotting layer for the LACE family.

New work should generally start from the Python successors; this
repository is preserved as the reference implementation accompanying the
original publication.

## Requirements

* MATLAB R2021a or later (R2024b used in CI)
* Image Processing Toolbox

## Installation

**Toolbox (recommended):** download `LACE.mltbx` from the
[latest release](https://github.com/zerotonin/LACE/releases) and
double-click it to install via the MATLAB Add-On Manager.

**From source:** clone the repository and add it to the MATLAB path:

```matlab
addpath(genpath('LACE'));
savepath;
```

## Usage

The GUIDE apps in `GUI/` are the primary entry points:

* `ET_GUI_Spline`  — spline / contour tracing and background handling
* `ET_GUI_ana_Fish`, `ET_GUI_ana_Fly` — species-specific analysis GUIs
* `ET_GUI_Benzer`  — Benzer-assay scripting

See `Contents.m` for the full module map (`help LACE`).

## Building locally

The repository uses the MATLAB build tool (`buildfile.m`):

```matlab
buildtool check       % static code analysis
buildtool test        % run the unit-test suite (tests/)
buildtool toolbox     % package release/LACE.mltbx
```

The same tasks run in CI through the
[MathWorks `matlab-actions`](https://github.com/matlab-actions) suite.

## Citation

If you use LACE, please cite:

> Garg, V., André, S., Giraldo, D., Heyer, L., Göpfert, M. C., Dosch, R.,
> & Geurten, B. R. H. (2022). A markerless pose estimator applicable to
> limbless animals. *Frontiers in Behavioral Neuroscience*, **16**,
> 819146. https://doi.org/10.3389/fnbeh.2022.819146

A machine-readable citation is provided in [`CITATION.cff`](CITATION.cff).

## License

GPL-3.0-or-later — see [LICENSE](LICENSE).
