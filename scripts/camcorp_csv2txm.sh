#!/bin/bash
CORPDIR="~/git/camcorp/camcorp/textcsv"
TREETOOLS="~/git/treetools"
ARRAY=( `ls ~/git/camcorp/camcorp/textcsv/*_text.csv` )
ELEMENTS=${#ARRAY[@]}
# echo each element in array 
# for loop
for (( i=0;i<$ELEMENTS;i++)); do
	csvfile=${ARRAY[${i}]}
	tmp=${csvfile/textcsv/texttab}
	xmltabfile=${tmp/.csv/.xml}
	echo $xmltabfile
	bstfile=$CORPDIR/bst/${xmltabfile##*/}
	txmfile=$CORPDIR/txm/xml-txm/${xmltabfile##*/}
	
	python3 $TREETOOLS/txt2xml.py -o $xmltabfile $csvfile csv 
	java -cp /usr/share/java/saxonb.jar net.sf.saxon.Transform $xmltabfile $TREETOOLS/xsl/import/xmltokentable.xsl > $bstfile
	java -cp /usr/share/java/saxonb.jar net.sf.saxon.Transform $bstfile $TREETOOLS/xsl/export/xml-txm.xsl use_id=id > $txmfile
done 
