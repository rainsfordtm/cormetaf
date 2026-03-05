#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
corpdir=${SCRIPT_DIR}/../camcorp-s
treetools=$HOME/git/treetools
d = $(pwd)
cd $treetools
echo $(pwd)
texts=( berinus conqueste mirlouis quatrelivres tristan vielouis avision chrfroiss memcomm quadrilogue saintre )
#for corpname in quadrilogue
for corpname in "${texts[@]}"
do
#corpname=barat
echo $corpname
#echo ${corpdir}/syntax2/${corpname}_syntax2.txt
echo "1. Import syntax2"
./importers/py/syn_importer.py -o /tmp/tmp1.xml ${corpdir}/syntax2/${corpname}_syntax2.txt syntax2
echo "2. Text CSV > XML file"
./importers/py/txt2xml.py -o /tmp/tmp2.xml ${corpdir}/csv/textcsv/${corpname}_text.csv csv
echo "3. Import text CSV"
saxonb-xslt /tmp/tmp2.xml importers/xsl/xmltokentable.xsl > /tmp/tmp3.xml
echo "4. Inject tags into syntax2 file"
./scripts/bst_tag_inject.py -m camcorp -o /tmp/tmp4.xml /tmp/tmp1.xml /tmp/tmp3.xml
echo "5. Run finalizer, saving pickled disc table on the side"
./scripts/syn2-simple_finalizer.py -o ${corpdir}/bst/${corpname}_bst.xml -d ${corpdir}/corptools/disc/${corpname}_disc.pickle /tmp/tmp4.xml
echo "6. Export BST to Tiger-XML"
saxonb-xslt ${corpdir}/bst/${corpname}_bst.xml exporters/xsl/tiger_subcorpus.xsl > ${corpdir}/tiger/xml/${corpname}_tiger.xml
done
cd $d
