N = 3 * pow(2, 30) + 1


a = 5  # 5 7

# Compute p = a^((N-1)/2) mod N
p = pow(a, (N - 1) // 2, N)


print("p =", p)

# -1 must be prime, 1 maybe prime,other composite
if p == N - 1:
    print(f"{a} is a quadratic residue modulo {N}, so {N} is  prime.")
elif p == 1:
    print(f"{a} is not a quadratic residue modulo {N}, so {N} may be prime.")
else:
    print(f"{a} is not a quadratic residue modulo {N}, so {N} is composite.")
