from random import SystemRandom
import sys

sys.set_int_max_str_digits(1000000)
random = SystemRandom()


class Polynomial:
    def __init__(self, p):
        self.p = p
        self.deg = random.randint(1, 2**8)
        self.poly = [random.randint(0, p) for _ in range(self.deg + 1)]

    def polyValue(self, x: int) -> int:
        return sum([(a * x**i) for i, a in enumerate(self.poly)])

    def getPoly(self):
        return self.poly


def getOddNumber(nbits):
    hbd = 2**nbits
    lbd = 2 ** (nbits // 2)
    n = random.randint(lbd, hbd)
    return n | 1


def checkInput(n):
    while n % 10 != 0:
        n //= 10
    if n < 10:
        return True
    return False


for _ in range(137):
    p = getOddNumber(16)
    share = Polynomial(p)
    x = int(input("Give me your x: "))

    assert checkInput(x)

    print(f"{share.polyValue(x)}")
    poly_in = list(map(int, input("Guess the poly?\n").split()))
    poly_secret = share.getPoly()

    assert len(poly_in) == len(poly_secret)

    for a, b in zip(poly_secret, poly_in):
        if a != b:
            print("Wrong!")
            exit(0)

print("Wow, a flag here~")
print(open("flag.txt", "rb").read().strip())
