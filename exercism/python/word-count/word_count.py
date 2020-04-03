import re

def word_count(sentence):
    words = filter(None, [x.strip() for x in re.split(r'_+|\W+',sentence.lower())])
    return dict((i, words.count(i)) for i in words)