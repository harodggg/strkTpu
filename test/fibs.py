def fibs(n):
    if n <= 0:
        return 1
    elif n == 1:
        return 3
    else:
        return pow(fibs(n - 1), 2) + pow(fibs(n - 2), 2)


def fibsx(x, n):
    if n <= 0:
        return 1
    elif n == 1:
        return x
    else:
        return pow(fibs(n - 1), 2) + pow(fibs(n - 2), 2)


if __name__ == "__main__":
    print(fibs(3))  # Example usage
    assert fibs(4) == 11981, "fibs(4) should be 11981"
