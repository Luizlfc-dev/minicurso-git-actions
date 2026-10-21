# 05. Anatomia de um workflow

A melhor forma de perder o medo de YAML é ler um arquivo inteiro com calma. Este capítulo pega o CI da prática, o [`ci.yml`](../.github/workflows/ci.yml), e explica cada linha. Depois mostra os recursos extras que aparecem no [`ola-actions.yml`](../.github/workflows/ola-actions.yml) e onde olhar o resultado de uma execução.

## Três regras de YAML antes de começar

O YAML é um formato de texto para dados estruturados, e três regras resolvem quase todos os erros de quem começa.

1. A indentação define a estrutura e é feita com espaços, nunca com tab. O costume é usar dois espaços por nível.
2. `chave: valor` define um campo. O espaço depois dos dois-pontos é obrigatório.
3. Uma linha que começa com `- ` é um item de lista. Os steps de um job são uma lista, por isso cada um começa com hífen.

Um texto que se estende por várias linhas usa `|`, e tudo que vem indentado abaixo vira um bloco só. É assim que se escreve um script de várias linhas no `run`.

## O ci.yml, linha por linha

```yaml
name: CI                                  # (1)

on:                                       # (2)
  pull_request:
    branches: [main]
  push:
    branches: [main]

permissions:                              # (3)
  contents: read

concurrency:                              # (4)
  group: ci-${{ github.ref }}
  cancel-in-progress: ${{ github.event_name == 'pull_request' }}

jobs:                                     # (5)
  verificar:                              # (6)
    name: Conferir config.txt             # (7)
    runs-on: ubuntu-latest                # (8)
    timeout-minutes: 5                    # (9)
    steps:                                # (10)
      - name: Baixar o código
        uses: actions/checkout@v7         # (11)
        with:
          persist-credentials: false      # (12)

      - name: Rodar a verificação
        run: bash scripts/check.sh config.txt   # (13)
```

| Nº | Linha | O que significa |
| --- | --- | --- |
| 1 | `name: CI` | O nome do workflow, que aparece na barra lateral da aba Actions |
| 2 | `on:` | Os eventos que disparam o workflow. Aqui, todo PR que mira a `main` e todo push na `main`, que é o que acontece quando um PR é mesclado |
| 3 | `permissions:` | O que o `GITHUB_TOKEN` pode fazer. `contents: read` permite só ler o código, e nada mais |
| 4 | `concurrency:` | Agrupa execuções pela ref. Num PR, se chegar um push novo, a execução anterior é cancelada. Na `main` a expressão dá falso, e a execução em andamento nunca é interrompida. O push novo espera ela terminar (se chegarem vários seguidos, só o mais novo fica na espera) |
| 5 | `jobs:` | Começa a lista de jobs. Este workflow tem um só |
| 6 | `verificar:` | O identificador do job, usado internamente (por exemplo em `needs: verificar`) |
| 7 | `name: Conferir config.txt` | O nome legível do job. É esse texto que aparece como check no PR e que você escolhe no ruleset |
| 8 | `runs-on: ubuntu-latest` | O tipo de máquina. Aqui, a imagem Linux mais recente oferecida pelo GitHub |
| 9 | `timeout-minutes: 5` | Se o job passar de 5 minutos, é cancelado. Sem isso, um script travado consumiria o limite padrão, que é bem maior |
| 10 | `steps:` | A lista de passos, executados em ordem, na mesma máquina |
| 11 | `uses: actions/checkout@v7` | Usa a action oficial que baixa o código. O `@v7` fixa a versão principal |
| 12 | `persist-credentials: false` | Diz à action para não deixar a credencial do Git salva na máquina, porque este job só lê arquivos |
| 13 | `run: bash scripts/check.sh config.txt` | Roda um comando de shell. Se o script sair com código diferente de zero, o step falha, o job falha e o check fica vermelho |

O ponto 13 é o coração do CI. O GitHub não sabe nada sobre o seu projeto, ele só olha o código de saída. Por isso qualquer verificação que você consiga escrever como um comando que sai com erro quando algo está errado vira um CI.

## O que o ola-actions.yml acrescenta

O workflow do exercício 1 mostra mais três recursos.

```yaml
on:
  push:
    branches: [main]
  workflow_dispatch:
    inputs:
      nome:
        description: Quem o workflow deve cumprimentar
        required: false
        default: turma
```

O `workflow_dispatch` coloca o botão Run workflow na aba Actions. Os `inputs` viram campos de formulário nesse botão, e o valor digitado chega no workflow como `inputs.nome`. O botão só aparece quando o arquivo do workflow está na branch padrão do repositório e para quem tem permissão de escrita.

```yaml
      - name: Contexto da execução
        env:
          ATOR: ${{ github.actor }}
          REF: ${{ github.ref }}
        run: |
          echo "Quem disparou ....: $ATOR"
          echo "Branch ou tag ....: $REF"
```

Aqui os valores do contexto `github` passam primeiro por variáveis de ambiente (`env`) e só então são usados no script, como `$ATOR`. Isso parece burocracia, mas é uma prática de segurança importante, explicada no [próximo arquivo](06-boas-praticas-e-seguranca.md).

```yaml
          } >> "$GITHUB_STEP_SUMMARY"
```

Tudo que um step escreve no arquivo indicado por `$GITHUB_STEP_SUMMARY` aparece formatado como Markdown na página da execução, logo abaixo do desenho dos jobs. É um jeito simples de deixar um resumo legível sem obrigar ninguém a abrir o log.

## Anotações de erro

O script `check.sh` imprime linhas num formato especial quando está rodando dentro do Actions.

```text
::error file=config.txt,line=11::UNIDADE precisa ser 'segundos' ou 'minutos' (valor atual: 's')
```

O GitHub reconhece esse formato e transforma a linha numa anotação, que aparece no resumo da execução e, num PR, junto da linha do arquivo na aba Files changed. Existem também `::warning::` e `::notice::`.

## Onde olhar o resultado

Toda execução fica registrada na aba Actions do repositório.

| Onde | O que você vê |
| --- | --- |
| Aba Actions, lista principal | Todas as execuções, com ícone de status, evento, branch e tempo |
| Barra lateral da aba Actions | Os workflows do repositório. Clicar em um filtra a lista e mostra o botão Run workflow, se houver |
| Página de uma execução | O desenho dos jobs, o resumo, as anotações e os artifacts |
| Página de um job | Cada step, que pode ser expandido para ler o log completo |
| PR, seção de checks | Os jobs que rodaram para o último commit do PR, com link para o log |

Os ícones são três. Círculo amarelo girando significa em andamento, check verde significa sucesso e X vermelho significa falha. Na página da execução, o botão Re-run jobs roda tudo de novo, o que ajuda quando a falha foi momentânea (uma queda de rede ao baixar algo, por exemplo).

Para quem prefere terminal, o GitHub CLI acompanha as execuções.

```bash
gh run list --limit 5        # últimas execuções
gh run watch                 # acompanha a execução em andamento
gh run view --log-failed     # mostra só o log dos steps que falharam
gh workflow run ola-actions.yml -f nome=turma   # dispara o workflow_dispatch
```

## Exercícios

1. No `ci.yml`, o que muda se você apagar o bloco `pull_request` do `on`?
2. Por que o nome do job (`name: Conferir config.txt`) importa para quem configura o ruleset?
3. Um step roda `grep -q "UNIDADE=segundos" config.txt`. Quando ele fica vermelho?

<details>
<summary>Respostas</summary>

1. O CI deixa de rodar nos PRs. Ele só rodaria depois do merge, no push na `main`, quando o erro já entrou.
2. Porque é esse nome que aparece como check e é ele que se escolhe na regra Require status checks to pass. Se você renomear o job, o ruleset passa a esperar um check que não existe mais.
3. Quando o `grep` não encontra o texto, porque nesse caso ele sai com código 1, e qualquer código diferente de zero faz o step falhar.

</details>

Próximo arquivo, [06. Boas práticas e segurança](06-boas-praticas-e-seguranca.md).
