from Crypto.Util.number import *
from secrets import randbits


def rc4(key, data):
    
    # the only modified part
    S = [randbits(8) for _ in range(256)]
    j = 0

    for idx in range(256):
        i = idx & 0xff
        j = (j + S[i] + key[i % len(key)]) % 256
        S[i] ^= S[j]
        S[j] ^= S[i]
        S[i] ^= S[j]

    i = 0
    j = 0
    output = []
    for byte in data:
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i] ^= S[j]
        S[j] ^= S[i]
        S[i] ^= S[j]
        K = S[(S[i] + S[j]) % 256]
        output.append(byte ^ K)
    return bytes(output)


flag = open("flag.txt", "rb").read().strip()
while True:
    try:
        key = input("🔑 ").encode()
        num = int(input("🔢 "))
    except:
        exit(0)
    for _ in range(num):
        ciphertext = rc4(key, flag)
        print(f"{ciphertext.hex()}")
