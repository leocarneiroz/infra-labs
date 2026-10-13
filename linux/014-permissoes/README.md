# 014 — Permissões Linux

## Objetivo

Entender permissões de arquivo no Linux (dono, grupo, outros), comandos `chmod` e `chown`, e o papel do `umask` na criação de arquivos novos.

## Parte 1 — Decifrando a string de permissão

Exemplo: `-rw-r--r--`

- **Primeiro caractere**: `-` = arquivo comum | `d` = diretório | `l` = link simbólico
- **9 caracteres seguintes**, em 3 grupos de 3:
  - **1º grupo** → permissões do **proprietário**
  - **2º grupo** → permissões do **grupo**
  - **3º grupo** → permissões de **outros**
- Dentro de cada grupo:
  - `r` (read) = ler/listar — valor **4**
  - `w` (write) = editar/apagar — valor **2**
  - `x` (execute) = executar/entrar no diretório — valor **1**

## Parte 2 — `chmod` numérico

| Valor | Significado | Exemplo |
|---|---|---|
| `600` | dono: `rw-` \| grupo: `---` \| outros: `---` | Arquivo sensível, só dono lê/escreve |
| `644` | dono: `rw-` \| grupo: `r--` \| outros: `r--` | Arquivo comum, todos leem, só dono escreve |
| `755` | dono: `rwx` \| grupo: `r-x` \| outros: `r-x` | Script executável por todos |
| `777` | dono: `rwx` \| grupo: `rwx` \| outros: `rwx` | **Nunca usar em produção** |

**Por que `777` é ruim:** qualquer usuário no sistema pode ler, editar e executar. Falha do princípio do menor privilégio — qualquer comprometimento vira modificação/execução arbitrária.

## Parte 3 — `chmod` simbólico

```bash
chmod u+x arquivo1.txt   # adiciona execução pro user
chmod g-w arquivo1.txt   # remove escrita do group
chmod o-r arquivo1.txt   # remove leitura pro other
chmod a+x arquivo1.txt   # adiciona execução pra todos
```

## Parte 4 — Script executável

Tentar `./script.sh` sem permissão de execução dá `Permission denied`. O kernel precisa da flag `x` pra rodar o arquivo.

Correção: `chmod +x script.sh` (ou `chmod a+x script.sh`).

### `./script.sh` vs `bash script.sh`

| | `./script.sh` | `bash script.sh` |
|---|---|---|
| Quem executa | O **kernel** | O **bash** já em execução |
| Como funciona | Lê o shebang (`#!/bin/bash`) e usa o interpretador | Passa o arquivo como argumento pro bash |
| Precisa de `x`? | **Sim** | **Não** (só leitura) |

**Conceito:** shebang (`#!`) é a primeira linha do script que diz ao kernel qual interpretador usar. `bash script.sh` contorna isso porque você já invoca o bash manualmente.

## Parte 5 — `chown` vs `chmod`

| Comando | O que muda | Precisa de sudo? |
|---|---|---|
| `chmod` | Permissões (`rwx`) | Só se o arquivo não for seu |
| `chown` | **Dono** e **grupo** do arquivo | **Sim**, sempre que trocar dono |

**Por que `chown` sem sudo dá `Operation not permitted`:** um usuário comum não pode "doar" um arquivo dele pra outro usuário. Só o root pode transferir propriedade.

## Parte 6 — `umask`

O `umask` é uma **máscara** que define as permissões padrão de arquivos/diretórios novos.

**Cálculo:** `permissão_final = permissão_padrão − umask`

- Arquivos novos: padrão `666`
- Diretórios novos: padrão `777`

| Umask | Arquivo novo | Diretório novo |
|---|---|---|
| `022` | `644` (`rw-r--r--`) | `755` (`rwxr-xr-x`) |
| `077` | `600` (`rw-------`) | `700` (`rwx------`) |

**Por que `077` em vez de `066`:** `066` protege arquivos (`600`), mas deixa diretórios como `711` — ainda permite travessia por "outros". `077` fecha tudo.

## Parte 7 — Cenário real (root + grupo de aplicação)

**Padrão de produção:**

```bash
sudo chown root:app-group /caminho/arquivo.conf
sudo chmod 640 /caminho/arquivo.conf
```

- **Dono `root`** → só o root altera permissões e dono
- **Grupo `app-group`** → membros do grupo leem
- **`other`** → sem acesso

**Por que é mais seguro que `app:app` + `600`:**

O padrão `app:app` + `600` deixa o próprio usuário da aplicação com poder de trocar permissões. Se a aplicação for comprometida, o atacante ganha poder sobre o arquivo.

O padrão `root:app-group` + `640` **separa quem controla de quem usa**:
- **Quem usa** → `app-group` (só lê)
- **Quem controla** → `root` (dono, decide permissões)

**Princípio do menor privilégio:** cada processo/usuário deve ter apenas o mínimo de permissão necessária.

## Perguntas obrigatórias

**1. Decifrar `rwxr-x---`:**
- **Proprietário:** ler, escrever, executar
- **Grupo:** ler, executar (sem escrita)
- **Outros:** nenhum acesso

**2. Cenários reais para `chmod`:**
- `600` → arquivos sensíveis (chaves SSH, `.env` com credenciais)
- `644` → arquivos comuns de leitura pública (HTML, configs não sensíveis)
- `666` → não usar. Todos editam, arquivo vulnerável a adulteração

**3. `chown` vs `chmod`:**
- `chown` → muda **dono/grupo** do arquivo. Exige privilégio (root pra transferir dono)
- `chmod` → muda **permissões** (`rwx`). O dono pode fazer sem sudo

**4. `umask 022`:**
- Arquivo novo → `644` (`rw-r--r--`)
- Diretório novo → `755` (`rwxr-xr-x`)

**5. Por que `777` é ruim:**
Dá permissão total pra qualquer usuário do sistema. Viola o menor privilégio. Qualquer falha de isolamento permite que outro usuário modifique ou execute código no arquivo.

**6. `root:app-group` + `640` vs `app:app` + `600`:**
O primeiro separa **controle** (`root`, que decide permissões) de **uso** (`app-group`, que só lê). O segundo concentra ambos no mesmo usuário — se o app for comprometido, o atacante pode alterar permissões.

## Aprendizado

- Permissão Linux é `dono + grupo + outros`, cada um com `r`, `w`, `x`
- `chmod` muda permissões; `chown` muda dono. São coisas diferentes
- **`644` não tem execução pro dono** — confundir `6` com `7` é erro clássico
- `./script.sh` exige bit `x` no arquivo (kernel usa shebang); `bash script.sh` não exige (bash lê como argumento)
- `umask 077` é mais seguro que `umask 066` porque também restringe diretórios
- **Princípio do menor privilégio:** em produção, o dono do arquivo de config é `root`, não o usuário da aplicação. Quem controla ≠ quem usa