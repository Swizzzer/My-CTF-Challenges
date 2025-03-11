import sys
from pwn import *
from tqdm import tqdm

# r = remote('ictf.031337.xyz', 42100)
r = process(["python3", "./chall.py"])

sys.set_int_max_str_digits(1000000)
NUM_TESTS = 137


def numberToBase(n: int, b: int) -> list[int]:
    if n == 0:
        return [0]
    if n == 1:
        return [1] * n
    digits = []
    while n:
        n, v = divmod(n, b)
        digits.append(v)
    return digits


if __name__ == "__main__":
    for _ in tqdm(range(NUM_TESTS)):
        r.recvuntil(b"Give me your x: ")
        r.sendline(b"111111111")
        val = int(r.recvline().decode())

        polynomial = numberToBase(val, 111111111)
        r.sendline(" ".join(map(str, polynomial)).encode())
    r.interactive()
