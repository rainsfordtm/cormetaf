#!/usr/bin/python3

#######################################################################
# Camcorp to R data                                                   #
# Tom Rainsford 2022-2023                                             #
#                                                                     #
# Script designed to export a syllabic verse text in a form suitable  #
# for further analysis in R.                                          #
# Used to generate the data for the analysis in the book (ch. 3).     #
# Loads texts from a pickled binary containing a                      #
# lib.sylltext.SyllabifiedText object.                                #
#######################################################################

import csv, pickle, os.path, sys

corpdir = '/home/tmr/git/camcorp/camcorp-v'
#textnames = [
#        'anjou', 'clermont', 'leger', 'gormont', 'marie', 'thebes', 'charrette',
#        'coinci', 'passjong', 'rosemeun', 'protheselaus', 'chevalerie',
#        'dolopathos', 'florimont', 'imagemonde', 'isopet', 'sacristain3',
#        'abeville', 'barat', 'barisel', 'eracle', 'poitiers', 'rennov', 
#        'feuillee', 'nicolas', 'palatinus', 'belledame', 'fortune', 'liberfort',
#        'meliador', 'testament', 'viemathurin', 'voirdit', 'griseldis', 'passgreb', 
#        'theophile', 'notredame', 'holofernes', 'troisgalans', 'pathelin', 
#        'chivalier', 'edmund', 'gui', 'richard', 'brendan', 'adam',
#        'blondel', 'chartier', 'christine', 'delahalle', 'froissart',
#        'gace', 'machaut', 'molinet', 'orleans', 'rutebeuf', 'thibaut',
#        'villon'
#]

# Decasyllables and alexandrines
textnames = [
    'alexis', 'roland', 'charroi', 'rou', 'antioche', 'raouli',
    'alexandre', 'ami', 'alexiso', 'berte', 'huon', 'behaigne', 'alexisa',
    'hugues', 'orloge', '3jugemens'
]

# Lyon couronné??

#corpdir = '/home/tmr/git/camcorp/camcorp-pv'
#textnames = [
#    'avision-pv', 'berinus-pv', 'chrfroiss-pv', 'conqueste-pv', 'memcomm-pv',
#    'mirlouis-pv', 'quadrilogue-pv', 'quatrelivres-pv', 'saintre-pv',
#    'tristan-pv', 'vielouis-pv'
#]

metadata = '/home/tmr/git/camcorp/camcorp-v/doc/metadata_r.csv'
outfile = '/home/tmr/out.csv'
line_lengths = [8]

def get_datapoints(textname, text, md):
    l = []
    for syllable in text.syllables:
        if not syllable.is_counted() or \
        not syllable.line.d.get('scan_ok') or \
        len(syllable.line.d['counted_sylls']) not in line_lengths:
            # Excluded here are syllables which don't have a metrical position
            # and syllables from lines that didn't scan (which aren't comparable)
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
        d['ISRHYME'] = 'true' if syllable.is_rhyme_syll() else 'false'
        d['ISCES'] = 'true' if syllable.is_at_cesura() else 'false'
        d['TEXT'] = textname
        d['TEXT.BOOK'] = md[textname]['TEXT.BOOK']
        d['DOC'] = md[textname]['DOC']
        d['DIALECT'] = md[textname]['DIALECT']
        d['TEXTTYPE'] = md[textname]['TEXTTYPE']
        d['VERSEFORM'] = md[textname]['VERSEFORM']
        d['WORDS'] = ' '.join(str(x['word']) for x in syllable.words)
        d['LEMMAS'] = ','.join(str(x['lemma']) for x in syllable.words)
        d['POSS'] = ' '.join(str(x['syntag2']) for x in syllable.words)
        d['LINE'] = ' '.join(str(x['word']) for x in syllable.line)
        # Calculate number of lexical stresses in the line in positions 1 to 7.
        d['STRINLINE'] = len(list(filter(
            lambda x: x.lex_stress(),
            syllable.line.d['counted_sylls'][:-1]
        )))
        # Calculate paroxytone
        d['PAROXYTONE'] = 'false'
        for word in syllable.words:
            if word.get_prosody()[1:] == 'po' and word.syllables[-1].is_counted():
                d['PAROXYTONE'] = 'true'
        # Calculate "score" according to the original stress clash
        # principles: 1 if no stress class, 0.5 if one of the
        # neighbouring syllables also bears a lexical stress
        if syllable.lex_stress():
            next_sylls = list(filter(
                lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) + 1,
                syllable.line.d['counted_sylls']
            ))
            last_sylls = list(filter(
                lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) - 1,
                syllable.line.d['counted_sylls']
            ))
            if (next_sylls and next_sylls[0].lex_stress()) or \
            (last_sylls and last_sylls[0].lex_stress()):
                # stress clash condition
                d['SCORE'] = 0.5
            else:
                # no stress class
                d['SCORE'] = 1
        else:
            # no stress
            d['SCORE'] = 0
        # Calculate NEXTSTR
        # next_syll = list(filter(
        #        lambda x: int(x.d.get('syll_in_line')) == int(d['METPOS']) + 1,
        #        syllable.line.d['counted_sylls']
        #    ))[0]
        #d['NEXTSTR'] = 'true' if next_syll.lex_stress() else 'false'
        l.append(d)
    return l

def load_text(textname):
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
    
def main():
    
    sys.path.append(os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
        '..'
    ))
    md = load_metadata(metadata)
    f = open(outfile, 'w')
    writer = csv.DictWriter(f, fieldnames=[
        'ID', 'ID.LINE', # unique IDs
        'LEXSTR', # dependent variable
        'METPOS', 'STRINLINE', 'PAROXYTONE', # level 1 predictors
        'SCORE', 'ISCES', 'ISRHYME', # Needed for the old-style analysis
        'TEXT', 'TEXT.BOOK', # random effect (level 2); printable name
        'DOC', 'DIALECT', 'TEXTTYPE', 'VERSEFORM', # level 2 predictors
        'REF', # human-readable reference to the datapoint
        'WORDS', 'LEMMAS', 'POSS', 'LINE' # additional human-readable info
    ])
    writer.writeheader()
    for textname in textnames:
        text = load_text(textname)
        for record in get_datapoints(textname, text, md):
            writer.writerow(record)
            
if __name__ == '__main__':
    main()
