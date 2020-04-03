def slices(series, length):
    if length > len(series) or length < 1:
        raise ValueError("Invalid length")
    return [[int(i) for i in series[start:start + length]]
            for start in range(len(series) - length + 1)]
