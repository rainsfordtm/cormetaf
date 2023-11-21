#!/usr/bin/python3

import csv, os.path, glob

phon_data='/home/tmr/Corpus/corpora/camcorp-pv/mycorpus/tools/phon_data_syllabified.csv'
corpdir='/tmp/blondel'

files = glob.glob(os.path.join(corpdir, '*_text.csv'))

with open(phon_data, 'r', newline='') as f:
    reader = csv.DictReader(f)
    pds = [x for x in reader]
    pd_header = reader.fieldnames

# Change data structure to SPEED IT UP!
pd_dict = {}
for pd in pds:
    pd_dict[pd['lex_id']] = pd['syllabified']
    
for fname in files:
    corpname = os.path.basename(fname)[:-9]
    print('Processing {}'.format(corpname)) 

    with open(fname, 'r', newline='') as f:
        reader = csv.DictReader(f)
        text = [x for x in reader]
        text_header = reader.fieldnames
    
    freq = []
    for j, word in enumerate(text):
        #print('Word {}'.format(j), end='\r')
        i, form = 0, dict()
        if word['lex_id'] in '.,;:!?"':
            word['syllabified'] = ''
        else:
            word['syllabified'] = pd_dict.get(word['lex_id'])
            
    if 'syllabified' not in text_header:
    	text_header.append('syllabified')

    with open(fname, 'w', newline='') as f:
        writer = csv.DictWriter(f, text_header)
        writer.writeheader()
        for word in text: writer.writerow(word)
