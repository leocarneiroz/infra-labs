# 009 — Primeiro Pod em Kubernetes com kind

## Objetivo
Criar um cluster local com kind, subir um Pod rodando a imagem `payfast-api:v1`
e acessar a aplicação via `kubectl port-forward`.

## Comandos

```bash
# Cria o cluster
kind create cluster --name payfast

# Carrega a imagem local dentro do cluster
kind load docker-image payfast-api:v1 --name payfast

# Aplica o manifesto do Pod
kubectl apply -f api-pod.yaml

# Confere
kubectl get pods

# Acessa a aplicação (túnel da porta 8082 do host pra 8000 do Pod)
kubectl port-forward pod/payfast-api 8082:8000
