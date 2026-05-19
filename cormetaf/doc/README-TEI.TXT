###############################################################################
# Corpus Métrique de l'ancien français (CorMétAF), version 0.9.0
# © Thomas Rainsford, ILR, Universität Stuttgart, 19th May 2026
# https://github.com/rainsfordtm/cormetaf
###############################################################################

*****
SETUP
*****

This version of the CorMétAF corpus contains two versions of the corpus
in XML format:

- xml-tei: TEI P5 compliant format
- xml-tei-zero: Simplified format

In the simplified format:
- the single "ana" attribute of the <w> node which contains all word-level
annotation is split in to separate attributes (simpler but not TEI compliant)
- annotated syllables in <standOff/> are removed.

*******
LICENSE
*******

The CorMétAF corpus is distributed under Creative Commons license
CC BY-NC-SA 4.0:

https://creativecommons.org/licenses/by-nc-sa/4.0/

* You are free to share this .zip file.

* You must give credit to the author by citing the corpus in the following way:
	Rainsford, Thomas. 2026. Corpus Métrique de l'ancien français (CorMétAF)
		version 0.9. Stuttgart: Institut für Linguistik/Romanistik. 
		<https://github.com/rainsfordtm/cormetaf>.
		
* You may not use this material for commercial purposes.

* You may modify the corpus and re-distribute the modified version under the same
	license.

*************************
COPYRIGHT AND ATTRIBUTION
*************************
	
Attribution and copyright status of the material in this corpus:

* The source texts are all in the public domain in the EU.
* Critical material from the source editions is excluded from the corpus,
	and this may remain under copyright.
* The following texts were extracted from the Nouveau Corpus d'Amsterdam
	(Stein et al. 2006,	https://github.com/michaniets/NCA) and contain
	part-of-speech annotation from the NCA: Adam (myst), AdHaleFeuill (feu),
	AlexisAlO (alexo), AmAm (amile), BodelNic (nic), Charroi (nima2),
	ChevBarAn (bar), Coincy (coinci), ComtePoit	(compoit), Gorm (gorm),
	JPriorat (abreja), PassJonglG (jongl), RCambr (raou), RenNouv (nouvel),
	RoseM (meun), Rou (rou2), RutebTheoph (the), YsLyon (yzop).
	Modified versions of these texts are redistributed in accordance
	with the provisions of the CC BY-NC-SA 4.0 licence of the NCA.

Stein, Achim, Pierre Kunstmann, and Martin-Dietrich Gleßgen, eds. 2006.
	Nouveau Corpus d'Amsterdam. Corpus informatique de textes littéraires
	d'ancien français (ca 1150-1350), établi par Anthonij Dees (Amsterdam
	1987). Stuttgart: Institut für Linguistik/Romanistik.
