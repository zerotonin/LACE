% LACE - Limbless Animal traCkEr
% Version 1.0.0 (R2024b) 15-Jun-2026
%
% ╔══════════════════════════════════════════════════════════════════╗
% ║  LACE — Contents                                                  ║
% ║  « marker-free pose estimator for limbless animals »              ║
% ╠══════════════════════════════════════════════════════════════════╣
% ║  Limbless Animal traCkEr — builds an animal's pose de novo        ║
% ║  from its contour: detects the contour, derives the body          ║
% ║  mid-line, and constructs a pseudo-skeleton of vertices and       ║
% ║  edges.  Applied to larval Drosophila and adult zebrafish.        ║
% ║                                                                   ║
% ║  Garg et al. (2022) Front. Behav. Neurosci. 16:819146.            ║
% ║  Successors: pyLACE and pyLACEpostHoc (Python ports).             ║
% ╚══════════════════════════════════════════════════════════════════╝
%
% Module folders
%   analysisScripts            - high-level analysis driver scripts
%   autoCorrection             - automatic trace / orientation correction
%   backgroundCalculation      - background estimation for segmentation
%   batch                      - batch / CPU-assignment helpers
%   DataIO                     - data import / export
%   deepLabCut                 - DeepLabCut interfacing utilities
%   evaluation                 - accuracy / benchmark evaluation
%   FILA_fluoImageLarva        - fluorescence imaging of larvae (FILA)
%   FMA_FishMovementAnalysis   - fish movement analysis (FMA)
%   GUI                        - GUIDE apps and sub-routines
%   HoughTransformDetection    - Hough-transform based detection
%   ImageManipulation          - image pre-processing / undistortion
%   misc                       - miscellaneous helpers
%   pix2mmFunc                 - pixel-to-millimetre calibration
%   Plot                       - plotting routines
%   postHocAna                 - post-hoc analysis
%   VR_InventorTools           - VR / Inventor / Norpix tooling
%
% See also: README.md, CITATION.cff
