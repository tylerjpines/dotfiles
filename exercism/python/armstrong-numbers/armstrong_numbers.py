20

def is_armstrong(number):
    numstr = str(number)
    armstrong = sum([int(i)**int(len(numstr)) for i in numstr])
    return armstrong == number

is_armstrong(20)