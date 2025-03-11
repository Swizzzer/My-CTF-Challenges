from Crypto.Util.number import bytes_to_long, getPrime
from secrets import randbits

LEN = 8
E = [randbits(64) for _ in range(LEN)]


"""
你知道的, Lilac是我兄弟, 我们曾并肩作战击败过许多对手
我和多项式很早就认识了，这家伙强得不可思议. 我认为我们三人组队可以产生很好的化学反应
有时候做出决定很难, 经过许多个日夜的思考, 我决定把天赋带到Sagemath
"""


def lilac(x: int, coff: list, exp: list, p: int) -> int:
    return sum([(c * pow(x, e, p)) for c, e in zip(coff, exp)]) % p


if __name__ == "__main__":
    ps = [getPrime(16) for _ in range(2 * LEN)]
    cs = [randbits(16) for _ in range(LEN)]
    m = bytes_to_long(
        open("flag.txt", "rb").read().strip().lstrip(b"flag{").rstrip(b"}")
    )
    output = []
    for p in ps:
        output.append(lilac(m, cs, E, p))
    print(f"{output}")
    print(f"{ps}")
    print(f"{cs}")
    print(f"{E}")
