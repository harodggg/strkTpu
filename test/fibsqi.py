from fibsm import field_prime


def fibsqi(n, x=3):
    a = 1
    b = x
    if n == 0:
        return a

    if n == 1:
        return b

    for i in range(2, n + 1):
        c = b
        b = (a**2 + b**2) % field_prime
        a = c
    return b


# a0 = 1, a1 = x ,a1022 =  2338775057, x ?
print(fibsqi(1022, 3141592))
