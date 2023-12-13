#!/bin/bash
CORPDIR="$HOME/git/camcorp/camcorp"
TREETOOLS="$HOME/git/treetools"
ARRAY=( `ls ~/git/camcorp/camcorp/csv/textcsv/*_text.csv` )
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
    txmfile=${txmfile/_text.xml/.xml}
	
	python3 $TREETOOLS/importers/py/txt2xml.py -o $xmltabfile $csvfile csv 
	java -cp $TREETOOLS/java/saxonb.jar net.sf.saxon.Transform $xmltabfile $TREETOOLS/importers/xsl/xmltokentable.xsl > $bstfile
	java -cp $TREETOOLS/java/saxonb.jar net.sf.saxon.Transform $bstfile $TREETOOLS/exporters/xsl/xml-txm.xsl use_id=id > $txmfile
done 
