Headline results with RNN Tagger 1.4.7
======================================

With gold part-of-speech, cross-reference in lexicon, post-process
------------------------------------------------------------------

+ Old French model 95.31% accurate, 389 -10s
+ Dual model 94.81% accurate, 333 -10s and 422 -1s (some of which may be right)
+ Middle French model 93.55% accurate, 756 -10s
    + best results (marginally) on avision and holofernes
    
With cross-reference in lexicon, post-process
---------------------------------------------

+ Old French model 94.03% accurate
    + best results for avision 96.06%, holophernes 93.45%
+ Dual model 93.38% accurate
+ Middle French model 88.84% accurate

RNN/NMT only
------------

+ Old French model 82.67%
+ Middle French model 80.92%
    + avision 91.54%, holophernes 92.18%
+ Dual model 75.47%, but 94.68% for lemmas where the models agree.


