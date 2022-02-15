# LACE

LACE Limbless_Animal_traCkEr  A Markerless Pose Estimator Applicable To Limbless Animals

This program can be used to track animals and is similar to project like:

* idtracker - https://www.idtracker.es/
* diverse nematod trackers - http://www.wormbook.org
* TRex - https://elifesciences.org/articles/64000
* ivTools - https://opensource.cit-ec.de/projects/ivtools

There is an article on the algorithm freely available at frontiersin.org 

The analysis of kinematics, locomotion, and spatial tasks relies on the accurate detection of animal positions and pose. Pose and position can be assessed with video analysis programs, the'trackers'. Most available trackers represent animals as single points in space (no pose information available) or use markers to build a skeletal representation of pose. Markers are either physical objects attached to the body (white balls, stickers, or paint) or they are defined in silico using recognisable body structures (e.g. joints, limbs, colour patterns). Physical markers often cannot be used if the animals are small, lack prominent body structures on which the markers can be placed, or live in environments such aquatic ones that might detach the marker. Here, we introduce a marker-free pose-estimator (LACE) that builds the pose of the animal de novo from its contour. LACE detects the contour of the animal and derives the body mid-line, building a pseudo-skeleton by defining vertices and edges. By applying LACE to analyse the pose of larval Drosophila melanogaster and adult zebrafish, we illustrate that LACE allows to quantify, for example, genetic alterations of persitalticmovements and gender-specific locomotion patterns that are associated with different body shapes. As illustrated by these examples, LACE provides a versatile method for assessing position, pose and movement patterns, even in animals without limbs.
