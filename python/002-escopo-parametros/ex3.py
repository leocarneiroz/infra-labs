def analisar_lista(lista):

	soma = sum(lista)

	media = sum(lista) / len(lista)

	qtd = len(lista)

	return soma, media, qtd

soma, media, qtd = analisar_lista([10, 20, 30, 40])
print(f"Soma: {soma}, Média: {media}, Itens: {qtd}")
