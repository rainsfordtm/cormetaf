# Corpus folder: Camcorp

This folder contains the sources for the full Cambridge thesis corpus
(the Camcorp): CSV files for the verse texts of the CorMétAF and the
full prose texts from which pseudo-verse was derived, as well as updated
metadata. It also contains configuration files necessary for exporting
the texts with phonological structure but without scanning them.

+ `cfg`: configuration files for the SylVA scripts (export without scansion)
    + `cv-phonemes.cfg`: segment definitions for the syllabified column
    + `unstressed_major_cats.txt`: unstressed monosyllable definitions
+ `csv/textcsv`: CSV sources for the corpora
+ `doc`: Metadata for the R export
