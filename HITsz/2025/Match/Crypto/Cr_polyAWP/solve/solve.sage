import re
d = 43

def inv(f):
    ff = f.lift().change_ring(QQ)
    gg = f.parent().modulus().change_ring(QQ)
    hh = xgcd(ff,gg)
    assert hh[0] == 1
    return f.parent()(hh[1])

def xDBLADD(a,b,X1,X2,X3):
    Z1 = Z2 = Z3 = 1
    if X1 == (): X1,Z1 = 1,0
    if X2 == (): X2,Z2 = 1,0
    if X3 == (): X3,Z3 = 1,0
    X4 = (X2^2-a*Z2^2)^2-8*b*X2*Z2^3
    Z4 = 4*(X2*Z2*(X2^2+a*Z2^2)+b*Z2^4)
    R = 2*(X2*Z3+X3*Z2)*(X2*X3+a*Z2*Z3)+4*b*Z2^2*Z3^2
    S = (X2*Z3-X3*Z2)^2
    X5 = R-S*X1
    Z5 = S
    return (X4*inv(Z4) if Z4 else ()), (X5*inv(Z5) if Z5 else ())

def xMUL(a,b,n,P):
    Q,PQ = (),P
    for bit in map(int,f'{n:b}'):
        if bit:
            P,Q = xDBLADD(a,b,PQ,P,Q)
        else:
            Q,P = xDBLADD(a,b,PQ,Q,P)
    return Q

################################################################

ls = list(sorted({u^2+d*v^2 for u in range(49+1) for v in range(7+1)} - {0}))
L = lcm(ls)     # or something

def fac(m, path=''):

    print(f'\x1b[33m    {"["+path+"]":9} ({int(m).bit_length()} bits)\x1b[0m')

    m = ZZ(m)
    if is_pseudoprime(m):
        print(f'--> \x1b[36m{m:#x}\x1b[0m'); print()
        return [m]

    R.<x> = Zmod(m)[]
    S.<J> = R.quotient(hilbert_class_polynomial(-d))                # J is a symbolic root of H_{-d} modulo n
    a0, b0 = (-3*J^2+3*1728*J), (-2*J^3+4*1728*J^2-2*1728^2*J)      # y^2 = x^3 + a0*x + b0 has j-invariant J

    for i in range(1,20):

        e = L^i                             # large smooth exponent
        P = J.parent().random_element()     # random point
        try:
            Q = xMUL(a0,b0,e, P)
            print(f'{i:2} nope')
#            print(P, Q)
            continue
        except ZeroDivisionError as e:      # probably found a divisor!
            vs = list(map(ZZ, re.findall('[0-9]+', e.args[0])))

        f = gcd(vs[0],m)
        if 1 < f < m:
            print(f'\x1b[34m{m:#x} = {f:#x} * {m//f:#x}\x1b[0m'); print()
            return fac(f, path+'L') + fac(m//f, path+'R')   # recursively factor the rest

    print('\x1b[31mFAILED\x1b[0m')
    exit(1)

n=42586679376954208840132885860409007163502770504043407757513231940938203684594648457531678141900146789903084486087744333378915885432116961603462667991522368776305723347509840950725004574206727717907703360112044423621347025280418647185205492447822617256038763762042357780919852666739665230538543668936732680650753
fac(n)