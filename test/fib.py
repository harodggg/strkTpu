def fib(n):
    if n <= 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fib(n - 1) + fib(n - 2)


if __name__ == "__main__":
    print(fib(10))  # Example usage
    assert fib(10) == 55, "fib(10) should be 55"
