# 004 — Bind mount com Nginx

## Objetivo
Servir página customizada via arquivo do host, sem rebuild.

## Comando
```bash
echo '<!DOCTYPE html><html><head><meta charset="UTF-8"></head><body><h1>PayFast — Sistema Interno</h1></body></html>' > ~/labs/index.html

docker run -d --name payfast-web -p 8081:80 \
  -v /home/leonardo_carneiro/labs/index.html:/usr/share/nginx/html/index.html \
  nginx
```

## Aprendizado
- Bind mount: `-v HOST:CONTAINER`. Arquivo no host vira o mesmo arquivo dentro do container.
- Mudança no host reflete **na hora** dentro do container, sem restart/rebuild.
- Path do Nginx dentro do container: `/usr/share/nginx/html/`.
- Sem `<meta charset="UTF-8">`, o navegador interpreta errado e aparece `â€"` em vez de `—`.
- Usar path absoluto (`/home/user/...`) em vez de `~` evita quebra em scripts/systemd.

## Erro/observação
Errei o path de destino primeiro (`/usr/share/nginx/index.html`, faltando `/html`). Nginx continuou servindo a página padrão. Mount errado = Nginx ignora.
