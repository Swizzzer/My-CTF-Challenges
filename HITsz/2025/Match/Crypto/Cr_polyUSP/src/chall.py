from Crypto.Util.number import bytes_to_long
def enc(msg, key):
    assert (1 << 32) <= key < (1 << 33), print("🔒")
    bitlen = msg.bit_length()

    msg <<= 32
    for i in range(bitlen - 1, -1, -1):
        if (msg >> (i + 32)) & 1:
            msg ^= (key << i)
    return msg


for _ in range(32):
        key = int(input("🔑 "))
        flag = open("flag.txt", "rb").read().strip()
        msg = bytes_to_long(flag)
        print(enc(msg, key))