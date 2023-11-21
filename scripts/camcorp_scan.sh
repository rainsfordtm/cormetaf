#!/bin/bash

#Global variables
scan_file="$HOME/git/syllabic-verse-analysis-code/scan_text.py"
corpdir="$HOME/Corpus/corpora/camcorp0.71V"
phonemes="${corpdir}/cfg/cv-phonemes.cfg"
unstressed="${corpdir}/cfg/unstressed_major_cats.txt"

# Alexandrines
echo "Alexandrines"
sp="${corpdir}/cfg/sp_12s.cfg"
texts=( rou antioche alexandre alexiso berte alexisa hugues )

for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Epic decasyllables
echo "Epic decasyllables"
sp="${corpdir}/cfg/sp_10s_ofr.cfg"
texts=( alexis roland charroi raouli ami huon )

for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Lyric decasyllables
echo "Lyric decasyllables (standard)"
sp="${corpdir}/cfg/sp_10s_midfr.cfg"
texts=( 3jugemens behaigne orloge )

for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Eurialus
echo "Eurialus"
sp="${corpdir}/cfg/sp_10s_eurialus.cfg"
$scan_file -t syntag2 $corpdir eurialus $sp $phonemes $unstressed -o scaneval bin paula

# Octosyllables
echo "Old French octosyllables"
sp="${corpdir}/cfg/sp_8s_ofr.cfg"
texts=( anjou clermont leger gormont marie thebes charrette coinci passjong rosemeun
protheselaus chevalerie dolopathos florimont imagemonde isopet sacristain3
abeville barat barisel eracle poitiers rennov feuillee nicolas palatinus )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Octosyllables
echo "Middle French octosyllables"
sp="${corpdir}/cfg/sp_8s_midfr.cfg"
texts=( belledame fortune liberfort meliador testament viemathurin voirdit
griseldis passgreb )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# OFr Octosyllables with short lines
echo "Old French octosyllables with short lines"
sp="${corpdir}/cfg/sp_8s_ofr_short.cfg"
texts=( theophile )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# MidFr Octosyllables with short lines
echo "Middle French octosyllables with short lines"
sp="${corpdir}/cfg/sp_8s_midfr_short.cfg"
texts=( notredame holofernes troisgalans pathelin )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Irregulars 
echo "Old French irregular octosyllables"
sp="${corpdir}/cfg/sp_8s_ofr_irreg.cfg"
texts=( chivalier edmund gui richard )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Brendan 
echo "Brendan"
sp="${corpdir}/cfg/sp_8s_ofr_brendan.cfg"
texts=( brendan )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

# Adam 
echo "Adam"
sp="${corpdir}/cfg/sp_8s_ofr_irreg_short.cfg"
texts=( adam )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
done

#########################
# LYRIC TEXTS
#########################

# Blondel
echo "blondel"
sp="${corpdir}/cfg/sp_lyr_ofr_blondel.cfg"
text="blondel"
$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula

# Christine
echo "christine"
sp="${corpdir}/cfg/sp_lyr_midfr_christine.cfg"
text="christine"
$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula

# Conon
echo "conon"
sp="${corpdir}/cfg/sp_lyr_ofr_conon.cfg"
text="conon"
$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
