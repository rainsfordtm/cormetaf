#!/bin/bash

#Global variables
scan_file="$HOME/git/syllabic-verse-analysis-code/scan_text.py"
corpdir="$HOME/git/camcorp/camcorp-pv"
phonemes="${corpdir}/cfg/cv-phonemes.cfg"
unstressed="${corpdir}/cfg/unstressed_major_cats.txt"

# Octosyllables
echo "Old French"
sp="${corpdir}/cfg/sp_8s_ofr.cfg"
sp6="${corpdir}/cfg/sp_6s_ofr.cfg"
texts=( berinus-pv conqueste-pv mirlouis-pv quatrelivres-pv tristan-pv vielouis-pv )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
	$scan_file -t syntag2 $corpdir ${text}6 $sp6 $phonemes $unstressed -o scaneval bin paula
done

# Octosyllables
echo "Middle French"
sp="${corpdir}/cfg/sp_8s_midfr.cfg"
sp6="${corpdir}/cfg/sp_6s_midfr.cfg"
texts=( avision-pv chrfroiss-pv memcomm-pv quadrilogue-pv saintre-pv )
for text in ${texts[@]}; do
	$scan_file -t syntag2 $corpdir $text $sp $phonemes $unstressed -o scaneval bin paula
	$scan_file -t syntag2 $corpdir ${text}6 $sp6 $phonemes $unstressed -o scaneval bin paula
done
