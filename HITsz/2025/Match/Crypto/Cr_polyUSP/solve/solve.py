from sage.all import *
from pwn import *
import ast
from Crypto.Util.number import long_to_bytes

def int2bv(i, n):
    return list(map(int, f"{i:0{n}b}"))[::-1]


def bv2int(bv):
    return sum([int(b) << i for i, b in enumerate(bv)])


R = GF(2)["x"]
x = R.gen()


def int2poly(i):
    return R(int2bv(i, 33))


def get_polys(extra):
    polys = set()
    while len(polys) < extra:
        while True:
            f = R.random_element(32)
            if f.is_irreducible():
                polys.add(f)
                break
    return list(polys)


extra = 16
polys = get_polys(extra)
int_polys = [bv2int(f) for f in polys]
conn = process(["python3", "chall.py"])
context.log_level = 'debug'

results = []
for G, poly in zip(polys, int_polys):
    conn.recvuntil("🔑 ")
    conn.sendline(str(poly))
    res = ast.literal_eval(conn.recvlineS().strip())
    results.append((G, res))
residues = []
for G, res in results:
    iv = (x**32).inverse_mod(G)
    ress = iv * int2poly(res) 
    residues.append(ress)
print(long_to_bytes(bv2int(crt(residues, polys))))
