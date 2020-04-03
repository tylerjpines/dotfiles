def is_isogram(string):
    letters = list(filter(lambda x:x.isalpha(),[i for i in string.lower()]))
    return len(set(letters)) == len(letters)