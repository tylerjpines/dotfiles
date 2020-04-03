def is_pangram(sentence):
    return len(set(filter(lambda x:x.isalpha(),[i for i in sentence.lower()]))) == 26