from random import SystemRandom
from functools import reduce

flag = open("flag.txt", "rb").read().strip().lstrip(b"HITCTF{").rstrip(b"}")
random = SystemRandom()
kk = len(flag)
print(f"🎁 {kk}")

k = kk // 2
smps = random.sample(range(kk), k)

coeffs = list(reversed(list(flag)))
evls = [
    reduce(lambda acc, c: acc * p + c, coeffs, 0)
    for p in smps
]

print(f"🌏 {smps}")
print(f"🎫 {evls}")