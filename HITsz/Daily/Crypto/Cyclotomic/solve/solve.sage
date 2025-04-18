from Crypto.Util.number import *


P.<x, y> = PolynomialRing(ZZ)
R.<z> = PolynomialRing(ZZ)
z = R.gens()[0]
def calculate_eta_all(eta, aa, bb, m, k):
    eta_all = []
    for i in range(k):
        temp = eta**(aa**i)
        add = temp
        for _ in range((m-1)//k - 1):
            add = add**bb
            temp += add
        eta_all.append(temp)
    return eta_all

def calculate_irreducible_polynomial(eta_all, m):
    h = 1
    for i in range(k):
        h *= (y - eta_all[i].lift())

    d = sum([x**i for i in range(m)])
    f_irreducible = h % d

    return f_irreducible, d

def pad_polynomial_coefficients(f, m):
    tmp = f.list()
    while len(tmp) < m:
        tmp.append(0)
    return tmp
    
def Factoring_with_Cyclotomic_Polynomials(k, n):
    
    if k == 1:
        print('k = 1')
        a = 2
        while True:
            print('a =', a)
            p = gcd(int(pow(a, n, n)-1), n)
            if p > 2**20 and n % p == 0:
                return p
            a += 1

    Phi = cyclotomic_polynomial(k)
    Psi = (z**k-1)//(cyclotomic_polynomial(k))
    print('Cyclotomic_Polynomials Phi:', Phi)
    print('Psi:', Psi)
    m = 1
    while True:
        useful = False
        while not useful:
            m += k
            if not isPrime(m):
                continue

            aa = primitive_root(m)
            ff = x**m - 1
            Q = P.quo(ff)
            eta = Q.gens()[0]
            for bb in range(2, m):
                if (bb**((m-1)//k)-1)//(bb-1) % m:
                    continue
                eta_all = calculate_eta_all(eta, aa, bb, m, k)
                f_irreducible, d = calculate_irreducible_polynomial(eta_all, m)
                if f_irreducible.subs(y=0) in ZZ:
                    useful = True
                    break

        print(aa, bb)
        print(m)

        eta0 = eta_all[0]
        eta0_pow = []
        for i in range(2, k):
            eta0_pow_i = (eta0**i).lift().subs(x=z)
            constant_term = eta0_pow_i.list()[0]
            if constant_term != 0:
                dd = (d-1).subs(x=z)
                eta0_pow_i = eta0_pow_i - constant_term - constant_term * dd
            eta0_pow.append(eta0_pow_i)

        coefficients = []
        for i in range(k):
            coefficients.append(pad_polynomial_coefficients(eta_all[i].lift().subs(x=z), m))

        A = matrix(QQ, coefficients)
        terget = [[-1]*k, [1] + [0]*(k-1)]
        for i in range(k-2):
            terget.append(A.solve_left(vector(pad_polynomial_coefficients(eta0_pow[i], m))))

        B = matrix(QQ, terget)

        U.<w> = PolynomialRing(QQ)
        w = U.gens()[0]
        eta1 = U(list((B**-1)[1]))
        f = f_irreducible.subs(y=w)
        V = U.quo(f)
        eta1 = V(eta1)

        C = matrix(QQ, k, k)
        C[0, 0] = 1
        for i in range(1, k):
            tmp = eta1**i
            C[i] = pad_polynomial_coefficients(tmp, k)

        K.<s> = PolynomialRing(Zmod(n))
        f_modulo = f_irreducible.subs(y=s)
        K_quo = K.quo(f_modulo)

        f_ZZ = f_irreducible.subs(y=z)
        try:
            sigma = matrix(Zmod(n), C)
        except:
            continue
        while True:
            g = R.random_element(k - 1)
            try:
                kk, _, h = xgcd(f_ZZ, g)
                h = inverse_mod(int(kk), n) * h
                break
            except:
                continue
        g = g.subs(y=x)       
        g_Q = K_quo(g)
        h_Q = K_quo(h)
        assert g_Q * h_Q == 1
        
        Psi_coefficients = Psi.coefficients()
        Psi_monomials = Psi.monomials()[::-1]
        if Psi_coefficients[0] < 0:
            yy = h_Q**(-Psi_coefficients[0]) 
        else:
            yy = g_Q**(Psi_coefficients[0]) 

        for i in range(1, len(Psi_monomials)):
            if Psi_coefficients[i] < 0:
                yy *= K_quo(list(vector(list(h_Q**(-Psi_coefficients[i]))) * Psi_monomials[i](sigma)))
            else:
                yy *= K_quo(list(vector(list(g_Q**(Psi_coefficients[i]))) * Psi_monomials[i](sigma)))
        yy = yy**n
        if gcd(yy[1], n) > 2**20:
            return gcd(yy[1], n)


if __name__ == "__main__":
    # p = getPrime(512)
    k = 10  # the k-th cyclotomic_polynomial
    Phi = cyclotomic_polynomial(k)
    # q = Phi(p)
    # r = getPrime(512*3)
    # r = 1
    n = 1125706678713691590613392814276171017238470043886999208333424659496198141840565844892882437710123689570148794586989249851943138741575168214595792768246694354651761182571140947314640387463842115716533895886357483797170988966050049083511217785852657751661184571142031045413428230442654800262988977804411297427744463871013184517518005213758867769301064405114760053393894284388270577038156848309332909016501958444714145952632340486699683992778325100412729519859424856812464200527123220239850992052298777343838925006318909421303862325115252378965173622376839624110089228607929923800013660666383098056238814015368070504172659863670179440006092969310585534030928645576654392697184624757645752132717545575490367110717743465221969260123796742647256504137090051479750582509291772963954776183293187621552944923756999510352352102580367484315945187417494149293755943173315395303696842208254932898576423138231229851090046125668574920170839
    pp = Factoring_with_Cyclotomic_Polynomials(k, n)
    assert not n % pp
    print('factor is found:', pp)