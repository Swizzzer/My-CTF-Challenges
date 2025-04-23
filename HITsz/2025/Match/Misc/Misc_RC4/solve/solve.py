from pwn import *
from collections import Counter
context.log_level = 'debug'
conn = process(["python3", "chall.py"])
conn.recvuntil("🔑 ")
conn.sendline(b"10000")
conn.recvuntil("🔢 ")
conn.sendline(b"50000")
data = conn.recvuntil("🔑 ", drop=True)
data = [bytes.fromhex(x.decode()) for x in data.split(b"\n") if x]
data = [[data[i][j] for i in range(len(data))] for j in range(len(data[0]))]
for c in data:
    print(chr(Counter(c).most_common(1)[0][0]), end="")
conn.close()