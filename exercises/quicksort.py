import sys
import re

def quicksort(L):
    if not L: return L
    pivot = L[0]
    total = ''
    def lt(x, pivot=pivot): return x<pivot
    def ge(x, pivot=pivot): return x>=pivot
    total += quicksort(filter(lt, L[1:])) + pivot + quicksort(filter(ge, L[1:]))
    total = total.replace(',', '')
    total = total.replace('[', '')
    total = total.replace(']', '')
    return total

strg = map(int, quicksort(sys.argv[1]))
print strg