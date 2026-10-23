numeros = [4, 8, 15, 16, 23, 42]
pares = 0
impares = 0

for numero in numeros:
    if numero % 2 == 0:
        print(f"{numero} é par.")
        pares += 1
    else:
        print(f"{numero} é ímpar.")
        impares += 1

print(f"Total de números pares: {pares}")
print(f"Total de números ímpares: {impares}")