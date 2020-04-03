import re
from itertools import groupby

def decode(string):
    decoded = ''
    for char in (re.findall('\d*\D', string)):
        if char[0].isdigit():
            subs = re.findall('\d+|\D', char)
            decoded += int(subs[0]) * subs[1]
        else:
            decoded += char
    return decoded

        
def encode(string):
    encoded = ''
    group = [list(b) for a, b in groupby(string)]
    for lst in group:
        if len(lst) > 1:
            encoded += f'{len(lst)}{lst[0]}'
        else:
            encoded += f'{lst[0]}'
    return encoded