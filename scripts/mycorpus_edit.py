#!/usr/bin/python3
###############################################################################
# Edits the textcsvs in a mycorpus format corpus according to input in a      #
# spreadsheet.                                                                #
###############################################################################

import argparse, csv, glob, os.path, re

def main(corpdir, change_file, regex=False):
    
    files = glob.glob(os.path.join(
        corpdir, 'csv', 'textcsv', '*_text.csv'
    ))
    
    with open(change_file, 'r', newline='') as f:
        ch_dreader = csv.DictReader(f)
        changes = [x for x in ch_dreader]
        
    for fname in files:
        corpname = os.path.basename(fname)[:-9]
        print('Processing {}'.format(corpname))
        with open(fname, 'r', newline='') as f:
            tx_dreader = csv.DictReader(f)
            text = [x for x in tx_dreader]
            fieldnames = tx_dreader.fieldnames
        for i, line in enumerate(text):
            in_vals = [
                corpname, line['wd_id'], line['word'].lower(), \
                line['syntag2'], line['lemma']
            ]
            for change in changes:
                match_vals = [
                    change['text'], change['wd_id'], change['word'], \
                    change['syntag2'], change['lemma']
                ]
                pairs = list(filter(
                    lambda x: x[1] != '*', zip(in_vals, match_vals)
                ))
                for pair in pairs:
                    if regex and not re.fullmatch(pair[1], pair[0]):
                        break
                    if not regex and not pair[0] == pair[1]:
                        break
                else:
                    # All relevant values match: make the change.
                    #print(pairs)
                    for key in ['syntag', 'syntag2', 'lemma']:
                        newval = change[key + '_out']
                        if newval == 'NONE': 
                            text[i][key] = ''
                        elif newval: # Empty cells have no newval; nothing is done.
                            text[i][key] = newval
        # Rewrite the file.
        with open(fname, 'w', newline='') as of:
            dwriter = csv.DictWriter(of, fieldnames)
            dwriter.writeheader()
            dwriter.writerows([x for x in text])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description = \
        'Modifies all textcsv files in corpus according to the rules ' + \
        'specified in the configuration file.'
        )
    parser.add_argument('corpdir', help='Corpus directory')
    parser.add_argument('change_file', help='File detailing changes')
    parser.add_argument('-r', '--regex', action='store_true', 
        help='Use regex matching.')
    # Convert Namespace to dict.
    args = vars(parser.parse_args())
    main(args.pop('corpdir'), args.pop('change_file'), args.pop('regex'))
