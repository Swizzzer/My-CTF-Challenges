from random import SystemRandom
from typing import Tuple
from functools import reduce
from operator import mul
from Crypto.Util.number import *


def pad(msg: bytes) -> bytes:
    return msg + b"\xff"*(16-len(msg) % 16)


def gen_prime(bit_length: int = 512) -> int:
    random = SystemRandom()

    def random_step() -> Tuple[int, int]:
        return (
            random.randint(1, 16),
            random.randint(1, 4)
        )

    def next_coords(x: int, y: int, a: int, b: int) -> Tuple[int, int]:
        return (
            abs(a * x + 43 * b * y),
            abs(b * x - a * y)
        )

    def verify(x: int, y: int) -> int:
        return len(bin((x + 1) ** 2 + 43 * y ** 2)[2:])

    while True:
        x, y = 1, 0
        while verify(x, y) < bit_length:
            a, b = random_step()
            x, y = next_coords(x, y, a, b)
            prime = (x + 1) ** 2 + 43 * y ** 2
        if isPrime(prime):
            return prime


n = reduce(mul, [gen_prime() for _ in "_"*2])
flag = open("flag.txt", "rb").read().strip()
m = bytes_to_long(pad(flag))
e = 0x10001
c = pow(m, e, n)
print(f"{n=}")
print(f"{c=}")
