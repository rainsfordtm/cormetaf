# Corpus métrique de l'ancien français (CorMétAF)

A metrically annotated corpus of Old and Middle French texts.

© Tom Rainsford, Institut für Linguistik/Romanistik, University of Stuttgart, 2008--2026

[https://sites.google.com/site/rainsfordtm/home](https://sites.google.com/site/rainsfordtm/home)

## Contents

+ [1. Description](#1-description)
+ [2. Quick start guide](#2-quick-start-guide)
+ [3. Annotation](#3-annotation)
	+ [3.1 Part-of-speech \(`pos`\)](#3-1-part-of-speech-pos)
	+ [3.2 Lemmatization \(`lemma`\)](#3-2-lemmatization-lemma)
	+ [3.3 Metrical annotation \(`line_met`, `metpos`, `soptem`, `prosody`\)](#3-3-metrical-annotation-line-met-metpos-soptem-prosody)
	+ [3.4 A note on `syllabified`](#3-4-a-note-on-syllabified)
+ [4. Subcorpora](#4-subcorpora)
+ [5. Sources](#5-sources)
+ [Appendix 1: `syntag` tagset](#appendix-1-syntag-tagset)
+ [Appendix 2: Slow start guide](#appendix-2-slow-start-guide)
+ [References](#references) 

## 1. Description

The CorMétAF contains seventy-five extracts from Old and Middle
French verse texts with manually verified metrical annotation. It
was initially developed in the course of my doctoral research
(Rainsford 2011: ch. 2) and has now been published to accompany the
publication of my monograph (Rainsford 2026). It is a forerunner
to the [_Old Gallo-Romance Corpus_](http://ogr-corpus.org) (OGR)
(Rainsford 2022, 2025). Releases of the corpus are designed to be used
with the [TXM](https://txm.gitpages.huma-num.fr/textometrie/en/) software
(Heiden 2010).

## 2. Quick start guide

1. Download and install the [TXM](https://txm.gitpages.huma-num.fr/textometrie/en/) software.
1. Download the `.txm` file included in the latest [release](https://github.com/rainsfordtm/cormetaf/releases) of the CorMétAF.
1. Open TXM.
1. Click `File > Load > a binary corpus (.txm)` and load the CORMETAF.

**Tip:** Check out the metrically aligned editions!
Open the edition (`CORMETAF090 (right-click) > Edition`),
click `default` (bottom left) and change to `metrical`.

## 3. Annotation

The CorMétAF is a metrically annotated corpus with verified lemmatization
and part-of-speech annotation.

**Table 1**: Annotation in the CorMétAF
| Type           | Properties                                             | Status (v0.9)  | Planned changes for v1.0  |
| -------------- | ------------------------------------------------------ | -------------- | ------------------------- |
| metrical       | `counted_syllables, prosody, metpos, soptem, line_met` | gold           | none                      |
| lemmatization  | `lemma`                                                | gold           | none                      |
| part-of-speech | `pos, syntag2`                                         | gold (syntags) | replace by Cattex-09 tags |
| XML markup     | n/a                                                    | n/a            | add major text divisions  |
| syntactic      | n/a                                                    | n/a            | n/a                       |
| morphological  | n/a                                                    | n/a            | n/a                       |

The metrical annotation, the lemmas and the part-of-speech tags have been
manually verified (gold). Text divisions above the level of the line
are __not__ coded, so there's no information on laisses, stanzas, divisions
between poems and songs or changes in speech turns in plays.
This makes some of the texts hard to interpret without the source
edition. These divisions will be added in the next version of the corpus.

The corpus has no morphological or syntactic annotation and it isn't
envisaged to add this at the present time.

### 3.1 Part-of-speech (`pos`)

The part-of-speech tags (`pos`) in the CorMétAF use a bespoke system
called `syntag`. The tagset is given in the [appendix](#appendix-1-syntag-tagset).
In version 1.0 of the corpus this will be replaced by a Cattex-09
part-of-speech tag.

The `pos` tag uses a version of `syntag` containing extra information
about clitics and pronouns by appending the following symbols to the
normal `syntag`:
+ `$$`: clitic (not subject), definitely unstressed
	+ attached to a finite verb
	+ not final in the verb group
+ `$`: preverbal weak pronoun, possibly unstressed:
	+ subject pronoun directly before the finite verb and clitics
	+ object pronoun before a non-finite verb.
+ `%`: postverbal weak pronoun, possibly unstressed:
	+ the final pronoun, object or subject, in a postverbal clitic group.
+ `%$': ambiguous attachment
	+ used for non-subject pronouns between the finite verb and an
	infinite, e.g. _lessez **m'**ester_, which could be enclitic on the
	finite verb or proclitic on the infinitive and whose attachment
	shifts diachronically.

If this more detailed information isn't required, it's recommended to
search the `syntag` rather than the `pos` property.

For the texts extracted from the _Nouveau Corpus d'Amsterdam_ (NCA),
which also has gold part-of-speech annotation, the NCA tag is given
as `pos_nca`.

### 3.2 Lemmatization (`lemma`)

Lemmatization in the CorMétAF is stored in the `lemma` column. Like
the _Old Gallo-Romance Corpus_ (OGR) and the _Base de Français médiéval_
(BFM), forms found in the _Dictionnaire du Moyen Français_ (DMF) are
preferred as standard lemmas. Unlike in the OGR, however, there
is no `lemma_src` column giving the precise source of the lemma.

In general, all forms which inflect for case and gender are lemmatized
using the oblique (masculine) singular, which in most cases corresponds
to the contemporary French masculine singular.  Notable exceptions are:
+ the nominative subject pronouns _je_, _tu_, _il_, _elle_ and the disjunctive
third-person pronouns _lui_, _li_, _eux_, _elles_ which are all treated as
separate lemmas;
+ the demonstratives _cil_ and _cist_, which follow the _DMF_ in being
lemmatized using the nominative singular;
+ a limited number of common nouns where the DMF **only** contains the 
nominative as the headword, typically because only the nominative survives
into contemporary French, e.g. _traître_, _prêtre_;
+ many proper nouns, in particular where the former nominative is
predominant in contemporary French, e.g. _Charles_ not _Charlon_.

### 3.3 Metrical annotation (`line_met`, `metpos`, `soptem`, `prosody`)

Metrical annotation is generated by the SylVA scripts and is found only
in the compiled corpus. It uses the same four word-level properties
as those found in the [OGR corpus](http://ogr-corpus.org/docs/annotation-sylls/#4-the-txm-version).

The tag `prosody` is a three-character string representing the prosody of the word.
The first character is the number of syllables. The final two characters
give the stress pattern, which is either:

+ `cl`: a clitic
+ `ox`: an oxytone, i.e. stressed on the final syllable
+ `po`: a paroxytone, i.e. stressed on the penultimate syllable
+ `pp`: a proparoxytone, i.e. stressed on the antepenultimate syllable

For example for _parler_ `[prosody="2ox"]` (a two-syllable oxytone), for 
_femme_ `[prosody="2po"]` (a two-syllable paroxytone) and for _le_ `[prosody="1cl"]`
(a monosyllabic clitic).

The tags `metpos` and `soptem` are strings representing the metrical position of all the syllables in the word.
+ The metrical position of each syllable is represented by two digits
	+ `metpos` counts forwards from the start of the line, `soptem` backwards from the end of the line. 
+ Different metrical positions are separated by dots
+ The final character of the string is either `r` (rhyme), `c` (caesura) or `-` (neither)

For example, the word _ancienur_ (_Alexis_, l. 1) occupies the last four metrical positions
of a decasyllabic line. It therefore has `[metpos="07.08.09.10.r"]` and `[soptem="04.03.02.01.r]`.

__Tip__: `soptem` is `metpos` backwards, to help remember which is which!

The tag `line_met` is a five-character string summarizing the key metrical properties of the line.

+ characters __1 and 2__: Number of syllables in the scanned line, e.g. `08`, `10`. If the line is irregular and could not
be scanned, this will give the actual number of syllables in the line rather than the target length.
+ character __3__: nature of the rhyme: **m**asculine, **f**eminine, or `-` for irregular lines.
+ character __4__: nature of the cæsura: **n**ormal (stress, word boundary), **e**pic (stress, uncounted
post-tonic syllables), **l**yric (no stress, word boundary), or `-` for irregular lines.
+ character __5__: cæsura position, e.g. `4`, or `-` for irregular lines. Note that the scanner only checks for cæsura in
standard positions, so for a decasyllable the cæsura will be either `4` or `-`.

`line_met` can be queried with a simple regex, e.g.:

+ decasyllable with epic cæsura: `[line_met="10.e."]`
+ octosyllable with feminine rhyme: `[line_met="08f.."]`

There is also a `line_correct` tag, with values `True` if the line could be scanned and `False` if not.

### 3.4 A note on `syllabified`

The source texts contain a `syllabified` column (see Rainsford 2022 and
the [OGR corpus documentation](http://ogr-corpus.org/docs/annotation-sylls/#42-syllabified)
for details).

In the CorMétAF, the `syllabified` column **doesn't** represent the
segmental structure of the word. It was automatically created from a far
simpler original annotation which just indicated the number of syllables and
a number of special syllable "types" (e.g. elidable syllables). However,
since the first version of the CorMétAF was created, the SylVA scripts
have been modified to require all phonological annotation to be in
`syllabified` format.

Long story short: you'll might notice that a word like _ouïr_ has the
`syllabified` representation `/V\.'C/V\` in the sources of the CorMétAF.
Yes, this is "wrong". No, there are no plans to "correct" it because it
provides all the information that the SylVA scripts need: a two-syllable,
vowel-initial word stressed on the final syllable.

## 4. Subcorpora

The corpus was designed to carry out diachronic statistical analyses
of the rhythm of French verse from 1000 to 1500, controlling for factors
such as the line length, the text type (narrative, lyric or drama) and
to a certain extent the dialectal origin of the text. For more information
about the composition of the corpus, see Rainsford (2011: ch. 2) or
Rainsford (2026: 154-169).

In the TXM release of the corpus, the following subcorpora are pre-defined:

**Table 2**: Predefined subcorpora in the CorMétAF for TXM
| Subcorpus      | Extracts | Description                            |  
| ---------      |--------- | -------------------------------------- |                          
| octosyllabes   |          | octosyllabic verse                     |
| decasyllabes   |          | decasyllabic verse (all narrative)     |
| alexandrins    |          | alexandrine verse (all narrative)      |
| anisosyllabique|          | Anglo-Norman anisosyllabic verse       |
| lyrique        |          | lyric verse (mixed line lengths)       |
| récit          |          | narrative verse (all line lengths)     |
| théâtre        |          | drama (all extracts octosyllabic)      |
| noyau          |          | narrative octosyllabic verse 1175-1300 |
| anglo-normand  |          | Anglo-Norman texts                     |
| continental    |          | continental Old French                 |
| avant 1175     |          | texts composed before 1175             |
| 1175-1299      |          | texts composed 1175-1299               |
| XIVs           |          | texts composed in the 14th century     |
| XVs            |          | texts composed in the 15th century     |

The prototypical text in the corpus is a narrative, octosyllabic verse
text composed between 1175 and 1300. All such texts are included in
the `noyau` subcorpus, and this is the only subcorpus which provides
balanced coverage of a range of continental scripta. 

## 5. Sources

There are two main sources for the texts and annotation in the CorMétAF:

+ the _Nouveau Corpus d'Amsterdam_ (NCA), version 2 (circa 2008) (Stein et al. 2006)
+ digitized print editions

All source texts in the corpus are in the public domain in the EU since
the authors died at least five centuries ago. Critical material from the
source editions may remain under copyright and is excluded from the
corpus.

**Table 3**: Texts from the NCA
| CorMétAF      | NCA         |
| ---------     | ----------- |
| Adam          | myst        |
| AdHaleFeuill  | feu         |
| AlexisAlO     | alexo       |
| AmAm          | amile       |
| BodelNic      | nic         |
| Charroi       | nima2       |
| ChevBarAn     | bar         |
| Coincy        | coinci      |
| ComtePoit     | compoit     |
| Gorm          | gorm        |
| JPriorat      | abreja      |
| PassJonglG    | jongl       |
| RCambr        | raou        |
| RenNouv       | nouvel      |
| RoseM         | meun        |
| Rou           | rou2        |
| RutebTheoph   | the         |
| YsLyon        | yzop        |

Texts from the NCA generally reproduce the source edition without
punctuation and capitalization, and in some cases with manuscript
variants reinstated. However, they have extremely detailed gold
part-of-speech tags (`pos_nca`). These were used as the basis for
the syntag annotation. Texts from the NCA are redistributed under a 
[CC BY-NC-SA 4.0 license](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en);
the latest version of the NCA is 
[available on GitHub](https://github.com/michaniets/NCA).

All other texts are sourced from digitized print editions and were 
annotated by me. I'm grateful for the support of the BFM team for their
continued support during the development of this corpus.

## Appendix 1: `syntag` tagset

The logic behind the `syntag` tagset is to code the underlying
morphological and syntactic properties of a given lexeme rather than 
its surface function. It seeks to operate on the principle of "one
lemma, one tag".
For example, all forms of the demonstrative *cil* are tagged as `Dem`
regardless of whether they function as determiners or pronouns. When the
corpus was created, this had an additional practical advantage, which was
that these kinds of tags were simpler to check for consistency. 

Some forms have a joint tag, for example `Pre+Det` for preposition plus
determiner portemanteau forms.

**Table A1**: Lexical classes
| __Tag__ | __Description__                                            |
| ------- | ---------------------------------------------------------- |
| `Adj`  | adjective in the broadest sense of "noun modifier"          |
| `Adv`  | adverb without prepositional uses                           |
| `Etr`  | foreign word                                                |
| `Exc`  | exclamation / interjection                                  |
| `Let`  | letter of the alphabet                                      |
| `N`    | noun                                                        |
| `Pnc`  | punctuation                                                 |
| `PrA`  | "preposition--adverbs", can occur without a nominal         |
| `QIs`  | quantifiers and indefinites, modifiers and pronouns         |
| `Vfin` | finite verb                                                 |
| `Vinf` | infinitive                                                  |
| `Vpp`  | past participle                                             |
| `Vprs` | present participle                                          |

**Table A2**: Functional classes
| __Tag__ | __Description__                        | __Lemmas__        |
| ------- | -------------------------------------- | ----------------- |
| `Crd`   | coordinating conjunction               | _ains, car, et, mais, ne, ou, que_ |
| `Dem`   | demonstrative modifiers/pronouns       | _ce, cil, cist, ledit_ |
| `Det`   | determiner (definite or possessive)    | _le, mon, ton, son, notre, votre, leur_ |
| `Neg`   | negative marker                        | _ne, non; pas, point, preu, mie_ |
| `NVP`   | non-verbal predicate                   | _oui, non, nenni; es; voici, voilà_ |
| `Pre`   | preposition (always with complement)   | _à, chez, de, dès, en, être, lez, o, par, pour, sans, sauf, vers_ |
| `Prn`   | pronoun (never modifier)               | _ce, ceci, cela, el, elle, en, eux, il, je, le, leur, li, lui, me, moi, néant, nous, o4, on, se, soi, te, toi, tu, vous, y_ |
| `Qux`   | _wh-_ (_qu-_) words                    | _combien, comment, dont, lequel, où, parquoi, pourquoi, quand, quanque, quant, que, quel, quelconque, qui, quiconque, quique, quoi, quoique_ |
| `Sub`   | subordinating conjunction              | _comme, desque, lorsque, puisque, quand, que, si, tresque, usque_ |

## Appendix 2: Slow start guide

The main branch of this repository contains the source files for the 
CorMétAF Corpus:
* `cormetaf/csv/textcsv`: source texts
* `cormetaf/cfg`: files necessary for compiling and exporting the corpus
* `cormetaf/doc`: metadata and documentation
* `scripts`: scripts to generate XML-TEI, HTML and PAULA-XML versions.

Before the corpus can be used, the source files must be processed and
exported using the syllabic verse analysis (SylVA) tools available on Sourceforge:  
[https://sourceforge.net/projects/syllabic-verse-analysis/](https://sourceforge.net/projects/syllabic-verse-analysis/)

The shell script which I use for the compilation is found in the repo
at [scripts/camcorp_scan.sh](./scripts/camcorp_scan.sh). This
produces XML-TEI output, which is also included in releases of the
corpus.

The resulting XML-TEI files must then be imported into TXM using the 
`XML TEI-Zero + CSV` importer. The XSLT and CSS files in the
[cormetaf/cfg/txm-import](./cormetaf/cfg/txm-import) folder 
must be added to the directory containing the XML files.
For metadata, the [camcorp/doc/metadata_full.ods](./camcorp/doc/metadata_full.ods)
spreadsheet has to be converted to a CSV file called `metadata.csv`,
which is also added to the directory containing the XML files.

## References

+ Heiden, Serge. 2010. 'The TXM Platform: Building open-source textual
analysis software compatible with the TEI encoding scheme'.
_24th Pacific Asia Conference on Language, Information and Computation (Sendai, Japan)_,
2010, 389-98. [http://halshs.archives-ouvertes.fr/docs/00/54/97/64/PDF/paclic24_sheiden.pdf](http://halshs.archives-ouvertes.fr/docs/00/54/97/64/PDF/paclic24_sheiden.pdf).
+ Rainsford, Thomas. 2011. 'The Emergence of Group Stress in Medieval
French'. PhD Thesis, University of Cambridge. [https://doi.org/10.17863/CAM.16503](https://doi.org/10.17863/CAM.16503).
+ Rainsford, Thomas. 2022. '_Old Gallo-Romance (OGR) Corpus_ : annotation
phonologique et métrique des plus anciens textes gallo-romans'. _SHS Web of Conferences_
138 (2022): 02007. [https://doi.org/10.1051/shsconf/202213802007](https://doi.org/10.1051/shsconf/202213802007).
+ Rainsford, Thomas. 2025. _Old Gallo-Romance Corpus_, version 1.0.
Stuttgart: Institut für Linguistik/Romanistik. [https://www.ogr-corpus.org](https://www.ogr-corpus.org).
+ Rainsford, Thomas. 2026. _La Disparition de l'accent de mot : Étude de la prosodie du français en diachronie_.
Paris: Garnier.
+ Stein, Achim, Pierre Kunstmann, and Martin-Dietrich Gleßgen, eds. 2006.
_Nouveau Corpus d'Amsterdam. Corpus informatique de textes littéraires d'ancien français (ca 1150-1350), établi par Anthonij Dees (Amsterdam 1987)_.
Stuttgart: Institut für Linguistik/Romanistik.
