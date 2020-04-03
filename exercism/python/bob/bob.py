def hey(string):
    if string.strip().isupper():
        return 'Whoa, chill out!'
    elif string.strip().endswith("?"):
        return 'Sure.'
    elif not string.strip():
        return 'Fine. Be that way!'
    else:
        return 'Whatever.'