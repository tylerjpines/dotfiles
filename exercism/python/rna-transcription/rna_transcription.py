def to_rna(dna):
    letters = {'G':'C', 'C':'G', 'T':'A', 'A':'U'}
    rna = map(lambda x: letters.get(x), [i for i in dna])
    if None in rna:
        return ''
    else:
        return ''.join(rna)