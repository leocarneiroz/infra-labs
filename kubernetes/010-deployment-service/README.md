# 010 — Deployment e Service Cluster IP

## Objetivo
Fazer um Deployment com 3 réplicas + Service ClusterIP

## Explicacao

Utilizado um Deployment com 3 replicas junto com o Service Cluster IP utilizado como ferramenta para que os dois em conjunto nao deixem que a aplicacao fique offline mesmo em caso de queda, ja que o Deployment mantem uma replica dos Pods substituindo assim que ocorrer o problema.

## Aprendizados

Deployment mantém estado declarado. Se um Pod cai, o ReplicaSet cria outro em segundos — sem intervenção.

Service descobre Pods por label (chave + valor), não por nome ou IP. Mudou o IP do Pod? O Service atualiza sozinho.

Fluxo do tráfego: cliente → Service:port → targetPort → Pod:containerPort → app.

## Dificuldades

Service procurava app.kubernetes.io/name=payfast-api, mas os Pods tinham label app=payfast-api. Chave diferente = não casou. Diagnosticado com kubectl get endpoints mostrando <none>, e kubectl describe svc mostrando o selector.

## Ambiente
- WSL2 Ubuntu 22.04
- Docker 27.x

## Comandos

kubectl apply -f api-deployment.yaml
kubectl apply -f api-service.yaml
kubectl get all
kubectl get endpoints payfast-service
kubectl get pods -w

## YAML

Deployment

api-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: payfast-deployment
  labels:
    app: payfast-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: payfast-api
  template:
    metadata:
      labels:
        app: payfast-api
    spec:
      containers:
      - name: payfast-container
        image: payfast-api:v1
        ports:
        - containerPort: 8000

Service

api-service.yaml

apiVersion: v1
kind: Service
metadata:
  name: payfast-service
spec:
  selector:
    app: payfast-api
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000


