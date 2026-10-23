def maior_de_idade(idade):
	return idade >= 18

idade = int(input("Qual sua idade? ")) #sabia sobre a logica do int, porem nao sabia como usa-lo na funcao entao tive que pesquisar
if maior_de_idade(idade):
	print ("Maior de idade")
else:
	print ("Menor de idade")

