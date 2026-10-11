# 012 — Troubleshooting de Pods

## Objetivo
Identificar e diagnosticar problemas em Pods em execução ou em falha.

## Arquivos

**`pod-1-pending.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-pending
spec:
  containers:
  - name: app
    image: nginx:alpine
    resources:
      requests:
        memory: "1000Gi"
        cpu: "1000"
```

**`pod-2-imagepull.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-imagepull
spec:
  containers:
  - name: app
    image: payfast-api:nao-existe
```

**`pod-3-crashloop.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-crashloop
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo 'iniciando'; sleep 2; exit 1"]
```

**`pod-4-running.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-running
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo 'algo deu errado aqui'; sleep 3600"]
```

**`pod-oom.yaml`**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pod-oom
spec:
  containers:
  - name: app
    image: polinux/stress
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "500M"]
    resources:
      limits:
        memory: "100Mi"
```

## Comandos de diagnóstico

```bash
kubectl get pods
kubectl describe pod <nome>
kubectl logs <nome>
kubectl logs <nome> --previous
kubectl get events --sort-by='.lastTimestamp'
```

## Resultado

| Cenário | Status | Causa raiz | Ferramenta que revelou |
|---|---|---|---|
| 1 | `Pending` | Recursos absurdos pedidos (1000Gi, 1000 CPU) — node sem capacidade | `describe` → `Events: Insufficient cpu/memory` |
| 2 | `ImagePullBackOff` | Tag da imagem inexistente (`nao-existe` em vez de `v1`) | `describe` → `Events: Failed to pull image` |
| 3 | `CrashLoopBackOff` | Comando terminava com `exit 1` — processo morre, K8s reinicia em loop | `logs --previous` + `describe` → `Back-off restarting` |
| 4 | `Running` | Não era erro — precisava ler o log de inicialização | `kubectl logs` (sem `--previous`) |
| 5 | `OOMKilled` | Container usou mais memória que o `limits.memory` permitia | `describe` → `Last State: OOMKilled` |

## Aprendizado

Troubleshooting é uma das habilidades mais importantes no dia a dia de infraestrutura. O fluxo que uso é:

1. `kubectl get pods` — checar o status geral de todos os Pods
2. `kubectl describe pod <nome>` — ler os **Events**, que contam a história do que deu errado
3. `kubectl logs <nome>` — ler a saída da aplicação
4. `kubectl logs <nome> --previous` — ler o log da instância anterior, quando o container reiniciou

Com esses dados é possível chegar à causa raiz do problema.

**Pontos-chave:**

- `Pending` normalmente é problema de agendamento (recursos insuficientes, node selector, taint)
- `ImagePullBackOff` pode ser imagem inexistente **ou** credencial faltando para registry privado — a mensagem do K8s não diferencia os dois
- `CrashLoopBackOff` é o K8s reiniciando o container porque o processo principal morre (exit code ≠ 0)
- `OOMKilled` é o kernel matando o processo por estourar `limits.memory` — exit code 137
- Container `Running` pode esconder problema: sempre vale conferir o log

## Dificuldades

- **CrashLoopBackOff** foi o mais complexo — exige entender o conceito de exit code e que todo processo em Linux termina com um código (0 = sucesso, diferente de 0 = erro).
- Usei `--previous` no cenário 4, mas o `pod-running` nunca reiniciou — então não havia instância anterior. O comando certo é `kubectl logs` sem flag. `--previous` só serve quando o container já reiniciou.
