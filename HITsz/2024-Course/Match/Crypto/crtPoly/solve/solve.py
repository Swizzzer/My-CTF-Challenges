from shared.polynomial import fast_polynomial_gcd
from Crypto.Util.number import *
import itertools
from tqdm import tqdm
import ast
from sage.all import *

with open("output.txt") as f:
    output = ast.literal_eval(f.readline())
    ps = ast.literal_eval(f.readline())
    cs = ast.literal_eval(f.readline())
    E = ast.literal_eval(f.readline())
ans = []
for p,out in tqdm(zip(ps,output), total=len(ps)):
    PR = PolynomialRing(GF(p),'x')
    x = PR.gen()
    g = x**(p-1)-1
    RP = PR.quotient(g)
    y = RP.gen()
    ff = 0
    for e,c in zip(E,cs):
        ff += c*y**e
    ff -= out
    f = ff.lift()
    h = fast_polynomial_gcd(f,g)
    roots = tuple(int(r[0]) for r in h.roots())
    ans.append(roots)

combs = itertools.product(*ans)  
results = []
for comb in tqdm(combs, total=prod(len(_) for _ in ans)):
    try:
        m = crt(list(comb), ps)
        results.append(m)
    except ValueError:
        pass

for res in results:
    if long_to_bytes(res).isascii():
        print(long_to_bytes(res))
        break