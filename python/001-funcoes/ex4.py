def contar_pares(lista):
	contador = 0
	for numero in lista:
		if numero % 2 == 0:
			contador += 1

	return contador

def contar_impares(lista):
	contador = 0
	for numero in lista:
		if numero % 2 != 0:
			contador += 1

	return contador

def imprimir_resultado(lista):
    pares = contar_pares(lista)
    impares = contar_impares(lista)
    print(f"Total de números pares: {pares}")
    print(f"Total de números ímpares: {impares}")

numeros = [4, 8, 15, 16, 23, 42]
imprimir_resultado(numeros)
