def analisar_lista(lista):

	soma = sum(lista)

	media = sum(lista) / len(lista)

	qtd = len(lista)

	return soma, media, qtd

def relatorio(lista):

	soma, media, qtd = analisar_lista(lista)

	print("=== Relatório ===")
	print(f"Lista: {lista}")
	print(f"Soma: {soma}")
	print(f"Média: {media}")
	print(f"Itens: {qtd}")

relatorio([10, 20, 30, 40])
relatorio([1, 2, 3])
