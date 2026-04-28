import sys


def shell_sort(a, size):
    h = 1
    while h <= size // 3:
        h = h * 3 + 1
    while h != 1:
        h //= 3
        for i in range(h, size):
            v = a[i]
            j = i
            while j >= h and a[j - h] > v:
                a[j] = a[j - h]
                j -= h
            if i != j:
                a[j] = v


def main():
    args = sys.argv[1:]
    a = []
    for arg in args:
        try:
            a.append(int(arg))
        except ValueError:
            a.append(0)

    size = len(a)  # FIX: el codigo original tenia len(a) - 1
    shell_sort(a, size)
    print("Output: ", end=" ")
    for num in a:
        print(num, end=" ")
    print()


if __name__ == "__main__":
    main()
