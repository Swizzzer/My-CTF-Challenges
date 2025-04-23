#!/usr/local/bin/sage
from sage.matrix.berlekamp_massey import berlekamp_massey
import re
import ast
F = GF(2)

def bytes_to_bits(byte_array):
    bits = []
    for byte in byte_array:
        for i in range(7, -1, -1):
            bits.append((byte >> i) & 1)
    return bits

def bits_to_bytes(bits):
    byte_array = bytearray()
    for i in range(0, len(bits), 8):
        byte = 0
        for bit in bits[i:i+8]:
            byte = (byte << 1) | bit
        byte_array.append(byte)
    return byte_array

def crack_lfsr(V,initial):
    l = len(V)
    bits = initial[:]
    for i in range(len(bits),len(enc_bits)):
        prev = vector(F,bits[-l:])
        bits.append(int(V.dot_product(prev)))
    decrypted_flag = bytes([a ^^ b for a,b in zip(enc,bits_to_bytes(bits))])
    return decrypted_flag
    
with open('output.txt') as f:
    enc = ast.literal_eval(f.readline())
    gift = ast.literal_eval(f.readline())

first_16 = bytes_to_bits([a ^^ b for a,b in zip(enc[:16],gift)])

enc_bits = bytes_to_bits(enc)
R.<x> = PolynomialRing(F)

B = [enc_bits[8*i] for i in range(len(enc_bits) // 8)]
minimal_poly_factor = berlekamp_massey([F(i) for i in B])
polys = list(R.polynomials(max_degree=128-minimal_poly_factor.degree()))[1:]

for poly in polys:
    candidate_annihilating_polynomial = minimal_poly_factor * poly
    V = vector(F,candidate_annihilating_polynomial.list()[:-1])
    possible = crack_lfsr(V,first_16)
    try:
        decoded = possible.decode('utf-8')
        matches = re.findall(r'HITCTF\{.*\}', decoded)
        if (len(matches) != 0):
            print(f'Found likely flag: {matches}')
            print(candidate_annihilating_polynomial)
            break
    except:
        continue