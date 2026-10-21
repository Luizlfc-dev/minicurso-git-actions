# Prática guiada, GitHub Actions funcionando de verdade

Nesta prática você cria a sua própria cópia deste repositório e faz três exercícios curtos. No primeiro, dispara um workflow pelo botão e lê o log. No segundo, quebra de propósito um arquivo num Pull Request, vê o CI ficar vermelho, corrige e vê voltar a verde. No terceiro, que é bônus, roda o mesmo job em Linux e Windows ao mesmo tempo e baixa o resultado. Cada execução leva poucos segundos, porque os workflows usam só bash e um arquivo de texto.

Todos os passos podem ser feitos pelo navegador. Quem tiver Git instalado encontra também o caminho pelo terminal, marcado como "Pelo terminal".

## Cronograma

| Etapa | Tempo | O que acontece |
| --- | --- | --- |
| Passo 0, preparar a sua cópia | 5 a 10 min | Criar o repositório a partir do template e conferir a aba Actions |
| Exercício 1, Olá, Actions | 10 min | Disparo manual, leitura do log, disparo por push |
| Exercício 2, CI que acusa erro | 20 min | Branch, PR, check vermelho, correção, check verde, merge |
| Exercício 3, bônus, matrix e artifact | 10 min | Dois sistemas operacionais em paralelo e download do relatório |
| Fechamento | 5 a 10 min | Check obrigatório no ruleset (opcional) e como desligar os workflows |

O total fica entre 50 e 60 minutos. Se o tempo apertar, pule o exercício 3 e faça o fechamento só falando.

## Passo 0, preparar a sua cópia

Você precisa de um repositório seu, para ter permissão de rodar workflows e abrir PRs. O caminho recomendado é o template.

### Caminho A, Use this template (recomendado)

1. Entre na página deste repositório no GitHub, logado na sua conta.
2. Clique no botão verde **Use this template** e escolha **Create a new repository**.
3. Em Owner, escolha a sua conta. Em Repository name, use `minicurso-git-actions` ou outro nome.
4. Deixe o repositório como **Public**. Em repositório público, o Actions com os runners padrão é gratuito.
5. Clique em **Create repository**.

O endereço do seu repositório vai ser `https://github.com/seu-usuario/minicurso-git-actions`, com o seu nome de usuário no lugar de `seu-usuario`.

### Caminho B, se o botão Use this template não aparecer

Faça um fork pelo botão **Fork**. Depois, siga dois cuidados que valem só para fork.

1. Abra a aba **Actions** do seu fork. O GitHub costuma mostrar um aviso de que os workflows estão desligados no fork, com um botão para habilitar. Leia e clique para habilitar.
2. Ao abrir um PR no exercício 2, confira o campo **base repository** no topo da tela. Ele vem apontando para o repositório original, e precisa apontar para o seu fork (`seu-usuario/minicurso-git-actions`).

### Caminho C, pelo terminal

Crie um repositório vazio no GitHub (botão **New**, sem README, sem `.gitignore`, sem licença) e envie uma cópia deste conteúdo para ele. Troque `usuario` pelo dono deste repositório e `seu-usuario` pelo seu.

```bash
git clone https://github.com/usuario/minicurso-git-actions.git
cd minicurso-git-actions
git remote set-url origin https://github.com/seu-usuario/minicurso-git-actions.git
git push -u origin main
```

Para o `git push` funcionar, o Git precisa estar autenticado no GitHub. O jeito mais simples é o `gh auth login`, e as alternativas estão na seção de autenticação do [guia sobre GitHub](../docs/03-github.md#autenticação). Se você usar um token de acesso pessoal, ele precisa ter permissão para alterar workflows (o escopo `workflow`, no token clássico). Sem isso, o GitHub recusa o push de qualquer arquivo dentro de `.github/workflows/`.

### Conferir a aba Actions

Abra a aba **Actions** do seu repositório. Na barra lateral devem aparecer três workflows, **Olá, Actions**, **CI** e **Bônus, matrix e artifact**. Pode ser que já existam execuções na lista, e pode ser que ela esteja vazia. As duas situações estão certas.

Se a aba Actions mostrar que o Actions está desabilitado, vá em **Settings**, depois **Actions**, depois **General**, e em Actions permissions escolha a opção que permite todas as actions. Salve e volte para a aba Actions.

## Exercício 1, Olá, Actions

**Objetivo.** Disparar um workflow pelo botão, ler o que ele imprimiu e ver o mesmo workflow rodar sozinho depois de um push.

O arquivo é o [`.github/workflows/ola-actions.yml`](../.github/workflows/ola-actions.yml). Abra e dê uma olhada antes de começar. Ele roda em dois eventos, `workflow_dispatch` (o botão) e `push` na `main`.

### Passos

1. Na aba **Actions**, clique em **Olá, Actions** na barra lateral.
2. À direita, clique em **Run workflow**. Vai abrir um pequeno formulário.
3. Deixe a branch como `main` e escreva o seu nome no campo **Quem o workflow deve cumprimentar**.
4. Clique no botão verde **Run workflow**.
5. Em alguns segundos aparece uma execução nova na lista, com um círculo amarelo. Se ela não aparecer, atualize a página. Clique nela.
6. Clique no job **Dizer olá** e expanda os steps **Mensagem de boas-vindas** e **Contexto da execução**.
7. Volte para a página da execução (clique em **Summary**) e veja a tabela gerada pelo último step.

Agora o disparo por push.

8. Volte para a página inicial do repositório, abra o arquivo `.github/workflows/ola-actions.yml` e clique no ícone de lápis (**Edit this file**).
9. Na linha do `echo "Olá, $NOME! ..."`, logo abaixo de `run: |`, troque o texto da mensagem por outro que você quiser. Mantenha as aspas, o `$NOME` e a indentação da linha. Para não ter surpresa, evite os caracteres `:`, `#`, `"` e `` ` `` dentro da mensagem.
10. Clique em **Commit changes**, deixe marcado **Commit directly to the main branch** e confirme.
11. Volte para a aba **Actions**.

Pelo terminal, os passos 8 a 10 ficam assim. Antes, confira se o Git está autenticado no GitHub, como explica a seção de autenticação do [guia sobre GitHub](../docs/03-github.md#autenticação). Como o arquivo editado é um workflow, um token de acesso pessoal precisa do escopo `workflow`.

```bash
git clone https://github.com/seu-usuario/minicurso-git-actions.git
cd minicurso-git-actions
# edite a mensagem em .github/workflows/ola-actions.yml
git add .github/workflows/ola-actions.yml
git commit -m "ci: muda a mensagem do olá"
git push
```

### O que deve aparecer

| Momento | Na aba Actions |
| --- | --- |
| Depois do passo 4 | Uma execução de **Olá, Actions** com o evento `workflow_dispatch` |
| No log do passo 6 | `Olá, <seu nome>!`, o seu usuário em "Quem disparou" e `refs/heads/main` em "Branch ou tag" |
| Depois do passo 10 | Duas execuções novas, uma de **Olá, Actions** e uma de **CI**, as duas com o evento `push` |

O CI também rodou porque ele escuta `push` na `main`. Um mesmo evento pode disparar vários workflows ao mesmo tempo, cada um de forma independente.

### Como confirmar que deu certo

As execuções terminam com check verde, e o log da execução por push mostra a mensagem nova que você escreveu. Repare que, no push, o nome cumprimentado é `turma`, porque não existe formulário nesse evento e o workflow usa o valor reserva.

### Se der errado

| Sintoma | Causa provável | O que fazer |
| --- | --- | --- |
| O botão Run workflow não aparece | Você não clicou no nome do workflow na barra lateral, ou o repositório não é seu | Clique em **Olá, Actions** na barra lateral. Confira se está no seu repositório |
| Na barra lateral, o nome do workflow virou o caminho do arquivo (`.github/workflows/ola-actions.yml`), e a execução falhou na hora com um aviso de problema no arquivo do workflow | O YAML ficou inválido depois da edição, quase sempre por indentação errada | Clique na execução para ler a mensagem, que indica a linha. Desfaça a edição ou confira a indentação e commite de novo |
| A execução ficou vermelha no step da mensagem | As aspas da linha do `echo` ficaram desbalanceadas | Abra o log do step, corrija a linha e commite de novo |
| A execução nova não aparece na lista | A página não atualizou sozinha | Atualize a página do navegador |
| A execução fica parada em Queued | Fila dos runners | Espere um ou dois minutos. Se continuar, veja o plano B com quem está apresentando |

## Exercício 2, CI que acusa erro

**Objetivo.** Ver um CI barrar um erro num Pull Request, ler o log para descobrir o motivo, corrigir e ver o check voltar a verde.

O workflow é o [`.github/workflows/ci.yml`](../.github/workflows/ci.yml). Ele roda o script [`scripts/check.sh`](../scripts/check.sh), que confere três regras do [`config.txt`](../config.txt).

| Chave | Regra |
| --- | --- |
| `PROJETO` | Obrigatória, sem espaço |
| `TEMPO_LIMITE` | Obrigatória, número inteiro de 1 a 300 |
| `UNIDADE` | Obrigatória, `segundos` ou `minutos` |

### Passos

1. Na aba **Actions**, clique em **CI** e confira que a última execução, a do exercício 1, está verde.
2. Abra o arquivo `config.txt` e clique no lápis para editar.
3. No fim do arquivo, acrescente a linha `CASAS_DECIMAIS=2`. Depois, "sem querer", troque `UNIDADE=segundos` por `UNIDADE=s`.
4. Clique em **Commit changes**. Desta vez escolha **Create a new branch for this commit and start a pull request** e dê à branch o nome `feat/casas-decimais`.
5. Clique em **Propose changes**. Na tela seguinte, confira que a base é a `main` do seu repositório e clique em **Create pull request**.
6. Role a página do PR até a caixa de checks. Espere terminar o check que começa com **CI / Conferir config.txt**.
7. Clique em **Details** ao lado do check vermelho e leia o log do step **Rodar a verificação**.
8. Volte ao PR e abra a aba **Files changed**. Procure a anotação de erro junto do `config.txt`.

Agora a correção.

9. Na aba **Files changed**, abra o menu do arquivo (os três pontos) e escolha editar, ou vá até a branch `feat/casas-decimais` e edite o `config.txt` por lá.
10. Volte `UNIDADE=s` para `UNIDADE=segundos`, mantendo a linha `CASAS_DECIMAIS=2`, e commite na mesma branch.
11. Volte ao PR e veja o check rodar de novo.
12. Com o check verde, abra a setinha ao lado do botão verde de merge (que vem como **Create a merge commit**), escolha **Squash and merge**, clique no botão, confirme e depois clique em **Delete branch**. O merge com squash junta os dois commits da branch num só.

Pelo terminal, o exercício inteiro fica assim.

```bash
git switch main
git pull
git switch -c feat/casas-decimais
# edite o config.txt: acrescente CASAS_DECIMAIS=2 e troque UNIDADE=segundos por UNIDADE=s
bash scripts/check.sh               # o mesmo script do CI, rodando na sua máquina
git commit -am "feat: adiciona casas decimais"
git push -u origin feat/casas-decimais
# abra o PR pelo link que o push imprime, ou com: gh pr create --base main --fill
# corrija UNIDADE=segundos e então:
bash scripts/check.sh
git commit -am "fix: mantém a unidade por extenso"
git push
# com o check verde, faça o merge com squash pelo navegador (passo 12)
# ou com: gh pr merge --squash --delete-branch
git switch main
git pull                            # traz o commit do merge para a sua máquina
git branch -d feat/casas-decimais   # se recusar, use -D (o squash muda o hash dos commits)
```

Rodando o script localmente com o erro, a saída é esta.

```console
$ bash scripts/check.sh
Conferindo config.txt

OK    PROJETO=minicurso-git-actions
OK    TEMPO_LIMITE=30
ERRO  UNIDADE precisa ser 'segundos' ou 'minutos' (valor atual: 's') (linha 11)

Resultado: 1 erro(s) encontrado(s). Corrija o config.txt e rode de novo.
```

### O que deve aparecer

| Momento | Onde | O quê |
| --- | --- | --- |
| Depois do passo 5 | PR, caixa de checks | **CI / Conferir config.txt** em andamento, com círculo amarelo |
| Depois do passo 6 | PR, caixa de checks | X vermelho e a mensagem de que alguns checks não passaram |
| No passo 7 | Log do step | A linha `UNIDADE precisa ser 'segundos' ou 'minutos' (valor atual: 's')` |
| Depois do passo 11 | PR, caixa de checks | Check verde e o botão de merge liberado |
| Depois do passo 12 | Aba Actions | Uma execução nova do **CI** e uma do **Olá, Actions**, por causa do push na `main` |

### Como confirmar que deu certo

O PR aparece como **Merged**, a `main` tem a linha `CASAS_DECIMAIS=2` com `UNIDADE=segundos`, e a última execução do CI na `main` está verde.

### Para pensar

O Git não acusou nada, porque a mudança não conflita com nenhuma outra. Quem sabe que a unidade precisa ser "segundos" é a regra do projeto, e o CI é essa regra escrita em código e executada em todo PR. Experimente também outros erros, como `TEMPO_LIMITE=trinta`, `TEMPO_LIMITE=500` ou apagar a linha `PROJETO`, e veja a mensagem que cada um gera.

### Se der errado

| Sintoma | Causa provável | O que fazer |
| --- | --- | --- |
| O check nem aparece no PR | O PR não mira a `main`, ou foi aberto contra o repositório original (caso de fork) | Confira a base do PR. Em fork, a base precisa ser o seu fork |
| O check ficou verde mesmo com o erro | A edição foi para outra branch ou o arquivo não foi salvo | Abra a aba Files changed do PR e confira se a linha `UNIDADE=s` está lá |
| O check continua vermelho depois da correção | Sobrou outro erro, ou a correção foi para outra branch | Leia o log de novo. Cada regra quebrada gera uma linha `ERRO` |
| O botão de merge está bloqueado mesmo com check verde | Há um ruleset exigindo aprovação | Veja o fechamento. Em repositório pessoal, deixe zero aprovações |

## Exercício 3 (bônus), matrix e artifact

**Objetivo.** Ver o mesmo job rodar em dois sistemas operacionais em paralelo e baixar um arquivo produzido pela execução.

O arquivo é o [`.github/workflows/bonus-matrix.yml`](../.github/workflows/bonus-matrix.yml). Ele só roda pelo botão, para não ocupar a fila à toa.

### Passos

1. Na aba **Actions**, clique em **Bônus, matrix e artifact**, depois em **Run workflow** e confirme.
2. Abra a execução. O desenho mostra dois jobs, **Relatório em ubuntu-latest** e **Relatório em windows-latest**, rodando ao mesmo tempo.
3. Abra cada job e compare as linhas `uname` e `bash` do step **Gerar o relatório**.
4. Quando os dois terminarem, volte para a página da execução (**Summary**) e role até a seção **Artifacts**.
5. Baixe `relatorio-ubuntu-latest` e `relatorio-windows-latest`. Cada um vem como `.zip` com um arquivo de texto dentro.

### O que deve aparecer

Dois jobs verdes, criados a partir de um único bloco `jobs` graças à matrix, e dois artifacts na página da execução. O job do Windows costuma demorar um pouco mais para começar que o do Linux.

### Como confirmar que deu certo

Os dois arquivos baixados mostram sistemas diferentes na linha `uname` e terminam com `Resultado: tudo certo.`.

### Para ir além

Acrescente `macos-latest` na lista `os` da matrix, commite na `main` e rode de novo. São três jobs agora.

Repare também no arquivo [`.gitattributes`](../.gitattributes), que força o fim de linha no formato Linux (LF) para todos os arquivos de texto. O Windows usa outro formato (CRLF), e um script bash salvo em CRLF não roda, porque o bash lê o caractere extra do fim da linha como parte do comando. Na sua máquina dá para ver o efeito convertendo uma cópia do script.

```bash
sed 's/$/\r/' scripts/check.sh > /tmp/check-crlf.sh
bash /tmp/check-crlf.sh config.txt
```

A saída é uma sequência de erros como `command not found` e `syntax error`. Com o `.gitattributes` no repositório, os dois jobs da matrix recebem o script em LF e passam. Problemas que só aparecem num sistema operacional são exatamente o que a matrix ajuda a encontrar cedo.

### Se der errado

| Sintoma | Causa provável | O que fazer |
| --- | --- | --- |
| Só o job do Linux terminou | Fila maior para Windows | Espere. Se o tempo acabar, mostre só o Linux e volte depois |
| A seção Artifacts não aparece | A execução ainda não terminou, ou o job falhou antes do upload | Espere os dois jobs terminarem e confira o log do step de upload |
| Os artifacts sumiram dias depois | O workflow guarda por 3 dias (`retention-days: 3`) | Rode de novo. Isso é o esperado |

## Fechamento

### Check obrigatório no ruleset (opcional)

Até aqui o CI avisa, mas não impede. Nada impede alguém de mesclar o PR com o X vermelho. Um ruleset transforma o aviso em regra. Faça só se sobrar tempo, e lembre que os nomes dos menus do GitHub mudam de tempos em tempos.

1. Vá em **Settings**, depois **Rules**, depois **Rulesets**.
2. Clique em **New ruleset** e escolha **New branch ruleset**.
3. Dê um nome, como `proteger-main`, e mude **Enforcement status** para **Active**.
4. Em **Target branches**, clique em **Add target** e escolha **Include default branch**.
5. Marque **Require a pull request before merging** e deixe **Required approvals** em `0`.
6. Marque **Require status checks to pass**, clique em **Add checks** e escolha **Conferir config.txt**. O check só aparece na busca depois de ter rodado ao menos uma vez no repositório.
7. Confira que **Block force pushes** está marcado e clique em **Create**.

Para testar, abra um PR com um erro no `config.txt`. O botão de merge fica bloqueado até o check passar. E uma edição direta na `main` pela interface passa a exigir um PR.

> [!WARNING]
> Se você colocar `1` em Required approvals e for a única pessoa no repositório, nenhum PR vai poder ser mesclado, porque o GitHub não deixa o autor aprovar o próprio PR. Em repositório pessoal, use `0` e mantenha só o check obrigatório.

### Desligar ou apagar os workflows ao final

Os workflows desta prática não gastam nada em repositório público e só rodam quando há push, PR ou clique. Mesmo assim, se quiser desligar, há três jeitos, do mais leve ao mais definitivo.

| Jeito | Como | Efeito |
| --- | --- | --- |
| Desabilitar um workflow | Aba **Actions**, clique no workflow, abra o menu de três pontos e escolha **Disable workflow** | O arquivo continua lá, mas o workflow não roda até ser habilitado de novo |
| Apagar o arquivo | Apague o `.yml` de `.github/workflows/` e commite | O workflow deixa de existir. As execuções antigas continuam no histórico da aba Actions |
| Desligar o Actions no repositório | **Settings**, **Actions**, **General**, opção de desabilitar as actions | Nenhum workflow roda no repositório |

Se o repositório era só para a prática, também dá para apagá-lo inteiro em **Settings**, na seção **Danger Zone**. Essa ação não tem volta.

## Depois do minicurso

Leia o [guia de estudos](../README.md#como-seguir) na ordem e consulte a [lista de comandos](../docs/comandos-git.md) quando bater a dúvida. Um bom próximo passo é escrever um workflow do zero para um projeto seu, começando pelo checklist do arquivo de [boas práticas e segurança](../docs/06-boas-praticas-e-seguranca.md).
