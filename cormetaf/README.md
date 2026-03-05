# Corpus folder: CorMétAF

This folder contains the files necessary to generate the CorMétAF
corpus, which contains only the verse texts from the original Cambridge
corpus.

+ `cfg`: configuration files for the SylVA scansion algorithm scripts
    + `sp*`: scansion parameter files
+ `cfg/txm-import`: XSL stylesheets for importing the corpus into TXM,
    including generation of the metrical view.
+ `doc`: metadata for the R export of the `CorMétAF`
+ `mycorpus/tools`: the old-style `phon_data` files, which contain the
    original syllabic annotation for every form in the corpus (`lex_id`
    to `syll_str` mapping). This is redundant and the annotation is
    now represented in the `syllabified` column of each CSV file.
    

