from os import urandom
from secrets import choice
import string


def gen_nn(nbits):
    return int.from_bytes(urandom(nbits // 8 + 1), 'big') & ((1 << nbits) - 1)


def pad(msg: str, n=384):
    table = string.digits + string.ascii_letters
    l = ''.join(choice(table) for _ in range(n))
    return l + msg


class LFSR:
    def __init__(self, n: int, key: int, mask: int):
        self.n = n
        self.state = key & ((1 << n) - 1)
        self.mask = mask

    def __call__(self):
        b = bin(self.state & self.mask).count('1')
        output = (b & 1) ^ (self.state & 1)
        self.state = (self.state >> 1) | ((b & 1) << self.n - 1)
        return output


class Cipher:
    def __init__(self):
        self.lsfr1 = LFSR(64, gen_nn(64), gen_nn(64))
        self.lsfr2 = LFSR(64, gen_nn(64), gen_nn(64))

    def bit(self):
        output = self.lsfr1() ^ self.lsfr2()
        return output

    def stream(self):
        while True:
            b = 0
            for i in reversed(range(8)):
                b |= self.bit() << i
            yield b

    def encrypt(self, data: bytes):
        return bytes(a ^ b for a, b in zip(data, self.stream()))


cipher = Cipher()
msg = pad(open("flag.txt", "r").read().strip()).encode()
enc = cipher.encrypt(msg)
print(f'{enc}')
print(f'{msg[:16]}')
