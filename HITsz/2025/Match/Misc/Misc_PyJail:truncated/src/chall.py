#!/usr/bin/python3 -S
flag = open("flag.txt", "r").read().strip()
code = input("🎫 ")[:7]
if '{' in code:
    print("🚫")
    exit(0)
else:
    eval(code)
