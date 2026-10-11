# 011 — ConfigMap e Secret

## Objetivo
Injetar variáveis de ambiente não sensíveis (ConfigMap) e sensíveis (Secret) numa aplicação rodando em K8s, sem hardcode na imagem.

## Arquivos

**`api-configmap.yaml`**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: payfast-api-config
data:
  APP_ENV: producao
  APP_PORT: "8000"
  LOG_LEVEL: info
```

**`api-secret.yaml`**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: payfast-api-secret
type: Opaque
stringData:
  DB_USER: payfast
  DB_PASSWORD: payfast123
```

**`api-deployment.yaml`**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payfast-api
  labels:
    app: payfast-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: payfast-api
  template:
    metadata:
      labels:
        app: payfast-api
    spec:
      containers:
      - name: payfast-api
        image: payfast-api:v1
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: payfast-api-config
        - secretRef:
            name: payfast-api-secret
```

## Comandos

```bash
kubectl apply -f api-configmap.yaml
kubectl apply -f api-secret.yaml
kubectl apply -f api-deployment.yaml

kubectl get pods
kubectl exec -it <nome-do-pod> -- env | grep -E 'APP_|DB_|LOG_'
kubectl get secret payfast-api-secret -o yaml
kubectl get secret payfast-api-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 -d; echo
```

## Resultado

Saída do `env | grep` dentro do Pod:
```
APP_ENV=producao
APP_PORT=8000
LOG_LEVEL=info
DB_USER=payfast
DB_PASSWORD=payfast123
```

## Aprendizado

- **ConfigMap** → variáveis não sensíveis. Armazena em texto puro no etcd.
- **Secret** → variáveis sensíveis. Armazena em base64 no etcd.
- **`stringData` vs `data`**: `stringData` você escreve texto puro no YAML, o K8s converte pra base64 ao salvar. `data` você já escreve em base64. O resultado final no cluster é **idêntico**.
- **base64 NÃO é criptografia**. Qualquer um com leitura no namespace decodifica: `kubectl get secret x -o jsonpath='{.data.KEY}' | base64 -d`.
- **`envFrom` vs `env.valueFrom`**: `envFrom` injeta tudo do ConfigMap/Secret de uma vez. `env.valueFrom` injeta uma por uma, com controle granular.
- **Env vars não atualizam em runtime**. Alterou o ConfigMap? Os Pods em execução mantêm valores antigos até serem reiniciados (`kubectl rollout restart deployment/<nome>`).

## Dificuldades

- Erro `unknown field "spec.template.spec.containers[0].envFrom"` — causado por indentação YAML incorreta. Diagnóstico com `cat -A` no arquivo.
- Confusão inicial entre `stringData` e `data` — achava que `stringData` dava segurança extra. Não dá. Ambos terminam em base64 no cluster.
- Cluster com Deployment antigo rodando em paralelo (do lab 010), consumindo recursos. Resolvido com `kubectl delete deployment payfast-deployment`.
