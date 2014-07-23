This folder contains a reference implementation of the algorithm described in the paper:

Seeing 3D chairs: exemplar part-based 2D-3D alignment using a large dataset of CAD models
M. Aubry, D. Maturana, A. Efros, B. Russell and J. Sivic
CVPR, 2014
http://www.di.ens.fr/willow/research/seeing3Dchairs/

This algorithm has minor differences with the one used to generate the results shown in the paper and may lead in some cases to slightly different results.

For any questions or problem, please contact Mathieu Aubry mathieu.aubry@polytechnique.org 



###########################
HOW TO USE
###########################

- at first use, run 
>> compile;

- demoGetAllDEs is a script that compute the discriminative elements from a set of rendered views. It must be runned before doing detection.

- demoDetection is a script that uses discriminative elements to detect the chairs in a test image it generates an html file visualizing the results after non-max suppression.

Both those functions can be used directly for a small number of 3D models, but should be parallelized to use the full set in a reasonnable place. The three functions to parallelize are marked int the corresponding functions.

###########################
ACKNOWLEDGMENTS
###########################

Some of the functions provided are derived from other people implementation:
- bboxoverlap
- Pedro Felzenswalb: http://www.cs.berkeley.edu/~rbg/latent/index.html. Functions features.cc


###########################
LICENSE
###########################



Copyright (c) 2014 Mathieu Aubry



Copyright (c) 2011-13 Andrea Vedaldi and Andrew Zisserman
Copyright (C) 2011, 2012 Ross Girshick, Pedro Felzenszwalb

Copyright (C) 2008, 2009, 2010 Pedro Felzenszwalb, Ross Girshick

Copyright (C) 2007 Pedro Felzenszwalb, Deva Ramanan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to 
the following conditions:



The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


