
def norm(v):
    return sum([i**2 for i in v])**(1/2)


def vectorMult(v, s):
    return [s*i for i in v]


def sum(v1, v2):
    if len(v1) != len(v2):
        return 0
    return [v1[i] + v2[i] for i in range(len(v1))]


def sProduct(v1, v2):
    if len(v1) != len(v2):
        return 0
    return sum([v1[i] * v2[i] for i in range(len(v1))])


def vProductR3(v1, v2):
    if len(v1) != 3 or len(v2) != 3:
        return 0
    return [(v1[1] * v2[2]) - (v2[1] * v1[2]),
            (v2[0] * v1[2]) - (v1[0] * v2[2]),
            (v1[0] * v2[1]) - (v2[0] * v1[1])]


def angle(v1, v2):
    return sProduct(v1, v2) / (norm(v1) * norm(v2))



def transM(m):
    return [list(x) for x in zip(*m)]


def sMultMatrix(m, s):
    return [vectorMult(x, s) for x in m]


def matrixAddition(m1, m2):
    if (len(m1) != len(m2)) or (len(m1[0]) != len(m2[0])):
        return 0
    return [sum(x, y) for x, y in zip(m1, m2)]


def matrixMult(m1, m2):
    tm = transM(m2)
    return [[sum(ea*eb for ea, eb in zip(a, b)) for b in tm] for a in m1]


def detSarrus(m):
    if len(m) != 3 or len(m[0]) != 3:
        return 0

    part1 = m[0][0]*m[1][1]*m[2][2] + m[0][1]*m[1][2]*m[0][2] + m[0][2]*m[1][0]*m[2][1]
    part2 = m[0][2]*m[1][1]*m[2][0] + m[0][0]*m[1][0]*m[2][1] + m[0][1]*m[1][0]*m[2][2]

    return (part1 - part2)