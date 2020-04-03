def detect_anagrams(word, candidates):
    return [x for x in candidates if sorted(word.lower()) == sorted(x.lower()) and x.lower() != word.lower()]