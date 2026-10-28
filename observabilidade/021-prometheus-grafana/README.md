# 021 — Observabilidade com Prometheus e Grafana

## Objetivo
Subir uma stack de monitoramento (Prometheus, Node Exporter e Grafana) via Docker Compose para coletar e visualizar métricas de um servidor Linux.

## Arquivos
- `prometheus.yml`: Configura o Prometheus para fazer scrape (coleta) a cada 15s no próprio Prometheus e no Node Exporter.
- `docker-compose.yml`: Orquestra os três containers na mesma rede (`monitoring`), garantindo a comunicação pelo nome do serviço.

## Comandos
```bash
docker compose up -d

## Resultado

Prometheus: Targets prometheus e node_exporter em estado UP.

Grafana: Dashboard oficial (ID 1860) importado, exibindo métricas de CPU, Memória, Rede e Disco do host.

## Aprendizado

Node Exporter: Atua como um tradutor, expondo métricas do kernel Linux em formato HTTP (/metrics) para que o Prometheus possa coletá-las.

Prometheus: É o banco de dados de séries temporais (TSDB) e coletor. Ele faz o scraping dos dados.

Grafana: Camada de visualização. Não armazena dados, apenas consulta o Prometheus e desenha dashboards.

Scrape Interval: 15 segundos é o padrão de mercado. Intervalos de 1s gerariam sobrecarga desnecessária de rede e armazenamento.

Observabilidade: Vai além do monitoramento tradicional ("está caindo?"). Através de métricas, logs e traces, permite entender a causa raiz dos problemas.

## Dificuldades

Nenhuma dificuldade de execução, o Docker Compose facilitou a orquestração da stack.
