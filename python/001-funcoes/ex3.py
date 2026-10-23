def contar_pares(lista):
	contador = 0
	for numero in lista:
		if numero % 2 == 0:
			contador += 1

	return contador

resultado = contar_pares([1, 2, 3, 4, 5, 6])
print(resultado)
