#!/usr/bin/python3

#######################################################################
# Camcorp to R data                                                   #
# Tom Rainsford 2022-2024                                             #
#                                                                     #
# Script designed to export a syllabic verse text in a form suitable  #
# for further analysis in R.                                          #
# Used to generate the data for the analysis in the book (ch. 3).     #
# Loads texts from a pickled binary containing a                      #
# lib.sylltext.SyllabifiedText object.                                #
#######################################################################

import argparse, csv, pickle, os.path, sys, textwrap

CORPDIR = '/home/tmr/git/camcorp/camcorp-v'
CORPDIR_PV = '/home/tmr/git/camcorp/camcorp-pv'
METADATA = '/home/tmr/git/camcorp/camcorp-v/doc/metadata_r.csv'
METADATA_PV = '/home/tmr/git/camcorp/camcorp-pv/doc/metadata_r.csv'

TEXTS_8S = [
        'anjou', 'clermont', 'leger', 'gormont', 'marie', 'thebes', 'charrette',
        'coinci', 'passjong', 'rosemeun', 'protheselaus', 'chevalerie',
        'dolopathos', 'florimont', 'imagemonde', 'isopet', 'sacristain3',
        'abeville', 'barat', 'barisel', 'eracle', 'poitiers', 'rennov', 
        'feuillee', 'nicolas', 'palatinus', 'belledame', 'fortune', 'liberfort',
        'meliador', 'viemathurin', 'voirdit', 'griseldis', 'passgreb', 
        'theophile', 'notredame', 'holofernes', 'troisgalans', 'pathelin', 
        'chivalier', 'edmund', 'gui', 'richard', 'brendan', 'adam',
        'blondel', 'chartier', 'christine', 'delahalle', 'froissart',
        'gace', 'machaut', 'molinet', 'orleans', 'rutebeuf', 'thibaut',
        'villon'
]

# Decasyllables and alexandrines
TEXTS_6S = [
    'alexis', 'roland', 'charroi', 'rou', 'antioche', 'raouli',
    'alexandre', 'ami', 'alexiso', 'berte', 'huon', 'behaigne', 'alexisa',
    'hugues', 'orloge', '3jugemens', 
    # Lyric corpus
    'blondel', 'chartier', 'christine', 'delahalle', 'froissart',
    'gace', 'machaut', 'molinet', 'orleans', 'rutebeuf', 'thibaut',
    'villon'
]

# Lyon couronné??

TEXTS_8PV = [
    'avision-pv', 'berinus-pv', 'chrfroiss-pv', 'conqueste-pv', 'memcomm-pv',
    'mirlouis-pv', 'quadrilogue-pv', 'quatrelivres-pv', 'saintre-pv',
    'tristan-pv', 'vielouis-pv'
]

FIELDNAMES = [
    'ID', 'ID.LINE', # IDs
    'LEXSTR', # lexical stress
    'METPOS', 'PAROXYTONE', 'ISWORDFINAL', # info about syllable
    'TEXT', 'TEXT.BOOK', # random effect (level 2); printable name
    'DOC', 'DIALECT', 'TEXTTYPE', 'VERSEFORM', # level 2 predictors
    'REF', # human-readable reference to the datapoint
    'WORDS', 'LEMMAS', 'POSS', 'LINE' # additional human-readable info
]

FIELDNAMES_AN = [
    'ID', 'ID.LINE', # IDs
    'LEXSTR', # lexical stress
    'METPOS', # info about unit
    'TEXT', 'TEXT.BOOK', # random effect (level 2); printable name
    'DOC', 'DIALECT', 'TEXTTYPE', 'VERSEFORM', # level 2 predictors
    'REF', # human-readable reference to the datapoint
    'LINE' # additional human-readable info
]

def _get_datapoint(syllable, textname):
    # Does the hard work of both get_datapoints functions
    d = {}
    d['ID'] = '{}.{:04d}.{:02d}'.format(
        textname, int(syllable.line.d.get('line_id')), int(syllable.d.get('syll_in_line'))
    )
    d['ID.LINE'] = '{}.{:04d}'.format(
        textname, int(syllable.line.d.get('line_id'))
    )
    d['REF'] = '{}, l. {}, s. {}'.format(
        textname, syllable.line.d.get('line_id'), syllable.d.get('syll_in_line')
    )
    d['LEXSTR'] = 'true' if syllable.lex_stress() else 'false'
    d['METPOS'] = syllable.d.get('syll_in_line')
    #d['ISRHYME'] = 'true' if syllable.is_rhyme_syll() else 'false'
    #d['ISCES'] = 'true' if syllable.is_at_cesura() else 'false'
    # Calculate ISWORDFINAL
    next_sylls = list(filter(
            lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) + 1,
            syllable.line.d['counted_sylls']
        ))
    try:
        d['ISWORDFINAL'] = 'true' if not syllable.words[-1] in next_sylls[0].words else 'false'
    except IndexError: # end of line
        d['ISWORDFINAL'] = 'true'
    d['WORDS'] = ' '.join(str(x['word']) for x in syllable.words)
    d['LEMMAS'] = ','.join(str(x['lemma']) for x in syllable.words)
    d['POSS'] = ' '.join(str(x['syntag2']) for x in syllable.words)
    d['LINE'] = ' '.join(str(x['word']) for x in syllable.line)
    # Calculate number of lexical stresses in the line in positions 1 to 7.
    #d['STRINLINE'] = len(list(filter(
    #    lambda x: x.lex_stress(),
    #    syllable.line.d['counted_sylls'][:-1]
    #)))
    # Calculate paroxytone
    d['PAROXYTONE'] = 'false'
    for word in syllable.words:
        if word.get_prosody()[1:] == 'po' and word.syllables[-1].is_counted():
            d['PAROXYTONE'] = 'true'
    # Calculate "score" according to the original stress clash
    # principles: 1 if no stress class, 0.5 if one of the
    # neighbouring syllables also bears a lexical stress
    #if syllable.lex_stress():
    #    next_sylls = list(filter(
    #        lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) + 1,
    #        syllable.line.d['counted_sylls']
    #    ))
    #    last_sylls = list(filter(
    #        lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) - 1,
    #        syllable.line.d['counted_sylls']
    #    ))
    #    if (next_sylls and next_sylls[0].lex_stress()) or \
    #    (last_sylls and last_sylls[0].lex_stress()):
    #        # stress clash condition
    #        d['SCORE'] = 0.5
    #    else:
    #        # no stress class
    #        d['SCORE'] = 1
    #else:
    #    # no stress
    #    d['SCORE'] = 0
    # Calculate NEXTSTR
    # next_syll = list(filter(
    #        lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) + 1,
    #        syllable.line.d['counted_sylls']
    #    ))[0]
    #d['NEXTSTR'] = 'true' if next_syll.lex_stress() else 'false'
    return d

def _get_datapoint_md(md, textname):
    d = {}
    d['TEXT'] = textname
    d['TEXT.BOOK'] = md[textname]['TEXT.BOOK']
    d['DOC'] = md[textname]['DOC']
    d['DIALECT'] = md[textname]['DIALECT']
    d['TEXTTYPE'] = md[textname]['TEXTTYPE']
    d['VERSEFORM'] = md[textname]['VERSEFORM']
    d['RHYME'] = md[textname]['RHYME']
    return d

def get_datapoints(textname, text, md, export='8s'):
    l = []
    # set line lengths
    if export == '6s':
        line_lengths = [10, 12]
    elif export == '6pv':
        line_lengths = [6]
    else:
        line_lengths = [8]
    for syllable in text.syllables:
        if not syllable.is_counted() or \
        not syllable.line.d.get('scan_ok') or \
        len(syllable.line.d['counted_sylls']) not in line_lengths or \
        (len(syllable.line.d['counted_sylls']) == 10 and syllable.line.d['cespos'] == 6): # exclude coupe italienne
            # Excluded here are syllables which don't have a metrical position
            # and syllables from lines that didn't scan (which aren't comparable)
            # and coupe italienne for ten syllable lines (not a lot of this)
            continue
        #if len(syllable.line.d['counted_sylls']) != line_length:
        #    print('Bad line: {}'.format(' '.join(str(x['word']) for x in syllable.line)))
        if not syllable in syllable.line.d['counted_sylls']:
            print('Error!')
        if syllable in syllable.line.d['counted_sylls'] and not 'syll_in_line' in syllable.d:
            print('Error! Syllable index {} has no syll_in_line'.format(
                str(syllable.line.d['counted_sylls'].index(syllable))
            ))
            print(syllable.line.d['counted_sylls'])
            print(syllable)
        # Get the datapoints
        d = _get_datapoint(syllable, textname)
        d.update(_get_datapoint_md(md, textname))
        l.append(d)
    return l
    
def get_datapoints_an(textname, text, md):
    # This does the same as get_datapoints but with a very different
    # means of calculating METPOS based on lexical stress position.
    l = []
    for line in text.lines: # Iterate by **lines**
        units = split_line(line)
        id_line = '{}.{:04d}'.format(
            textname, int(line.d.get('line_id'))
        )
        ll = []
        for i, unit in enumerate(units): # Iterate units
            if not unit:
                break
            try:
                d = _get_datapoint(unit[0], textname) # Get initial set of data from first syllable.
            except AttributeError:
                print(line)
                print(line.d)
                print(units)
            d['METPOS'] = i+1 # Reset METPOS to the unit number
            # Reset LEXSTR to read 'true' if ANY syllable contains a LEXSTR
            d['LEXSTR'] = 'true' if sum([x.lex_stress() for x in unit]) > 0 else 'false'
            d['REF'] = d['REF'][:-1] + str(i+1) # update REF
            d['ID'] = d['ID'][:-1] + str(i+1) # update ID
            # Extra properties can be added here too
            # Add metadata
            d.update(_get_datapoint_md(md, textname))
            # Append d to the list
            ll.append(d)
        else: # for...else
            l.extend(ll) # add the units unless the loop was broken
    return l
            
def split_line(line, iterations=2):
    # Repeatedly halves a line into 2^iterations units
    def halve(syllables):
        n = len(syllables)
        if n == 0: # two empty lists
            return [[], []]
        elif n == 1: # right-headed default, so empty + single syll
            return [[], syllables]
        elif n / 2 == n // 2: # divisible by two, easy-peasy
            try:
                return [syllables[:n // 2], syllables[n // 2:]]
            except:
                print(syllables)
                print(n)
                print(n/2)
                raise
        else: # at least three syllables in this unit
            l1 = syllables[:n//2] # first part
            midsyll = syllables[n//2] # mid syllable
            l2 = syllables[n//2 + 1:] # second part
            if midsyll.lex_stress(): # stress mid syllable
                l1_stress = sum([x.lex_stress() for x in l1])
                l2_stress = sum([x.lex_stress() for x in l2])
                if l1_stress < l2_stress: # override default to distribute stress
                    l1.append(midsyll)
                else:
                    l2 = [midsyll] + l2
            else: # right-headed default
                l2 = [midsyll] + l2
            return [l1, l2]
        
    units = [line.d.get('counted_sylls', [])]
    for iteration in range(iterations):
        l = []
        for unit in units:
            try:
                l.extend(halve(unit))
            except:
                print(line)
                print(line.d)
                print(units)
                print(l)
                print(iteration)
                raise
        units = l
    return units

def load_text(corpdir, textname):
    path = os.path.join(corpdir, 'bin', textname)
    with open(path, 'rb') as f:
        return pickle.load(f)
        
def load_metadata(path):
    with open(path, 'r', newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        md = {}
        for record in reader:
            md[record['TEXT']] = record
    return md
    
def main(export='8s'):
    
    sys.path.append(os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
        '..'
    ))
    # 1. Set up variables
    metadata = METADATA_PV if export in ['8pv', '6pv', 'anpv'] else METADATA
    corpdir = CORPDIR_PV if export in ['8pv', '6pv', 'anpv'] else CORPDIR 
    fieldnames = FIELDNAMES_AN if export in ['an', 'anpv'] else FIELDNAMES
    if export == '6s':
        textnames = TEXTS_6S
        outfile = 'deca-alex.csv'
    elif export in ['8pv', '6pv']:
        textnames = TEXTS_8PV
        outfile = 'octosyllables-pv.csv'
        if export == '6pv':
            textnames = [x + '6' for x in textnames]
            outfile = 'six-pv.csv'
    elif export == 'an':
        textnames = TEXTS_8S
        outfile = 'octosyllables-an.csv'
    elif export == 'anpv':
        textnames = TEXTS_8PV
        outfile = 'octosyllables-pv-an.csv'
    else:
        textnames = TEXTS_8S
        outfile = 'octosyllables.csv'
    
    # 2. Load metadata
    md = load_metadata(metadata)
    f = open(outfile, 'w')
    writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction='ignore')
    writer.writeheader()
    for textname in textnames:
        text = load_text(corpdir, textname)
        l = get_datapoints_an(textname, text, md) if export in ['an', 'anpv'] else get_datapoints(textname, text, md, export)
        for record in l:
            writer.writerow(record)
            
if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawTextHelpFormatter,
        description = \
        'Camcorp to R data.'
    )
    parser.add_argument(
        'export', type=str, nargs='?',  default='8s',
        choices=['6s', '8s', '6pv', '8pv', 'an', 'anpv'],
        help=textwrap.dedent('''
            Which file to export?
            6s        Decasyllables and Alexandrines (deca-alex.csv)
            8s        Octosyllables (octosyllables.csv)
            8pv       Octosyllabic pseudo-vers (octosyllables-pv.csv)
            6pv       Six-syllable pseudo-vers (six-pv.csv)
            an        Anglo-Norman stress-based texts (octosyllables-an.csv)
            anpv      Anglo-Norman stress-based texts (octosyllables-pv-an.csv)
            '''
        )
    )
    kwargs = vars(parser.parse_args())
    main(**kwargs)
