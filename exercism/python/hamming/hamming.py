def distance(dna1, dna2):
    if len(dna1) == len(dna2):
        comparison = map(lambda (x,y): y == dna2[x],
            [(i,j) for i,j in enumerate(dna1)])
        return comparison.count(False)
    else:
        raise ValueError