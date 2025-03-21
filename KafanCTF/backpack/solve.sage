M = [391141429, 3478124220, 3336047727, 3527421942, 1597786510, 2019990264, 2744862007, 3898825252, 486177504, 184886860, 781690097, 63429722, 1180618910, 1947105626, 1555881410, 2578824499]
ct = [2290375496, 6377613399, 1851683274, 3008635871, 4955741497, 4493937495, 7933494809, 3313318585, 5587460370, 2681599712, 2618169990, 5354670310, 3407564684, 1851683274, 3862218622, 2290375496, 671064364, 671064364, 3249888863, 4805770273, 2618169990, 5354670310, 6049818905, 3313318585, 2618169990, 5354670310, 2633373371]

n = len(M)
L = matrix.zero(n + 1)
flag = []
for S in ct:
    n = len(M)
    L = matrix.zero(n + 1)
    for row, x in enumerate(M):
        L[row, row] = 2
        L[row, -1] = x

    L[-1, :] = 1
    L[-1, -1] = S
    L = L.LLL()
    res = L[0]
    flagc = []
    for i in res[:-1]:
        flagc.append((1-i)//2)
    binary_string = ''.join(map(str, flagc))
    integer_value = int(binary_string, 2)
    flag.append(integer_value)

noisy_c = [210, 205, 200, 226, 230, 217, 207, 209, 227, 212, 196, 206, 202, 200, 220, 210, 192, 192, 193, 195, 196, 206, 219, 209, 196, 206, 232]
flag = [102]

for i in range(len(noisy_c)):
    flag.append(noisy_c[i]-flag[i])

print("".join(map(chr, flag)))
