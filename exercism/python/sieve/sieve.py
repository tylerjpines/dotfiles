'''
def sieve(limit):
    return [x for x in range(2, (limit + 1)) if all(x % y != 0 for y in range(2, x))]

'''

