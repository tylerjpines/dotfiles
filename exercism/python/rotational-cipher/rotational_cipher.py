
import string

def rotate(text, key):
    trans = str.maketrans(string.ascii_lowercase + string.ascii_uppercase,
                          string.ascii_lowercase[key:] +
                          string.ascii_lowercase[:key] +
                          string.ascii_uppercase[key:] +
                          string.ascii_uppercase[:key])

    return text.translate(trans)
