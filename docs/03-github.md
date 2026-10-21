# 03. GitHub

Se no Git cada pessoa tem a história inteira na própria máquina, para que serve o GitHub? Serve para o time ter um ponto de encontro combinado. Tecnicamente qualquer cópia do repositório vale tanto quanto outra, mas ninguém quer trocar commits por pen drive. O GitHub é a cópia que o time escolheu como referência, e em cima dela ele oferece o que o Git sozinho não tem, como Pull Request, revisão, issues, regras de proteção e automação com Actions.

## Repositório local e remoto

O repositório que está no GitHub é, para o seu Git, um remoto. Por convenção, o remoto principal se chama `origin`. Quando você clona um repositório, o Git já cria o `origin` apontando para o endereço de onde veio.

```console
$ git remote -v
origin  https://github.com/usuario/projeto.git (fetch)
origin  https://github.com/usuario/projeto.git (push)
```

O Git também guarda uma fotografia do que existe no remoto, as branches remotas, com nomes como `origin/main`. Essa fotografia só é atualizada quando você conversa com o remoto, e é por isso que o `git status` às vezes diz que você está atrasado ou adiantado.

## Os quatro verbos da sincronização

| Comando | O que faz | Mexe nos seus arquivos? |
| --- | --- | --- |
| `git clone <url>` | Baixa o repositório inteiro, com toda a história, e configura o `origin` | Cria a pasta |
| `git fetch` | Atualiza a fotografia do remoto (`origin/main`) | Não |
| `git pull` | Faz `fetch` e integra as novidades na sua branch | Sim |
| `git push` | Envia os seus commits para o remoto | Não |

O `fetch` é sempre seguro, porque só olha. O `pull` traz e integra, então pode gerar conflito. Na primeira vez que você envia uma branch nova, use `git push -u origin nome-da-branch`. O `-u` liga a branch local à remota, e daí em diante basta `git push`.

## Por que o push foi recusado?

É a pergunta mais comum de quem trabalha em dupla. Acontece quando alguém enviou commits para a mesma branch depois do seu último `pull`. O remoto tem algo que você não tem, e o Git se recusa a apagar o trabalho da outra pessoa.

```console
$ git push
To github.com:usuario/projeto.git
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'github.com:usuario/projeto.git'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally.
```

A solução é trazer o que falta e tentar de novo.

```bash
git pull --rebase   # traz os commits do remoto e reaplica os seus por cima
git push
```

A tentação de resolver com `git push --force` é grande, e é exatamente o que não se deve fazer numa branch compartilhada. O `--force` substitui a branch remota pela sua e apaga os commits do colega. Se você realmente precisa reescrever uma branch que é só sua (depois de um `commit --amend`, por exemplo), prefira `git push --force-with-lease`, que recusa o envio se alguém tiver mexido na branch desde a última vez que você olhou.

## Autenticação

Para enviar commits ao GitHub, ele precisa saber quem você é. Senha da conta não funciona mais para isso. Há três caminhos comuns.

| Caminho | Como funciona | Para quem |
| --- | --- | --- |
| GitHub CLI (`gh auth login`) | Faz login pelo navegador e configura o Git para usar essa credencial | O jeito mais simples para iniciantes |
| HTTPS com gerenciador de credenciais | O Git Credential Manager guarda o login depois da primeira vez | Quem instalou o Git for Windows ou o GitHub Desktop |
| SSH | Você gera um par de chaves, cadastra a chave pública no GitHub e usa endereços `git@github.com:...` | Quem usa o terminal todo dia |

Tokens de acesso pessoal também funcionam no lugar da senha, mas são um segredo como outro qualquer. Nunca cole um token em arquivo do repositório, em print ou em chat.

## Fork, template e clone

São três formas de ter "a sua versão" de um repositório, e cada uma serve para uma coisa.

| Forma | O que é | Quando usar |
| --- | --- | --- |
| Clone | Cópia local de um repositório, ligada ao original | Você tem permissão de escrita, ou só quer ler o código |
| Fork | Cópia do repositório inteiro na sua conta, ligada ao original | Você quer contribuir com um projeto em que não tem permissão de escrita |
| Template | Repositório novo na sua conta, criado a partir dos arquivos do original, sem ligação e sem a história | Você quer partir de um modelo e seguir sozinho |

Para a prática deste minicurso, o template é o caminho recomendado. Num fork, o GitHub deixa os workflows desligados até você habilitar, e o PR aberto pela interface aponta por padrão para o repositório original, não para o seu. Com o template, o repositório é seu desde o começo, e os PRs ficam entre branches dele mesmo.

## Issues

Issue é o lugar para registrar um bug, uma ideia ou uma tarefa. Ela tem título, descrição, comentários, labels e responsável. O melhor hábito é ligar o PR à issue que ele resolve, escrevendo na descrição do PR uma palavra-chave como `Closes #12`. Quando o PR for mesclado na branch padrão, a issue 12 é fechada automaticamente.

## Rulesets, as regras do repositório

Sem regra nenhuma, qualquer pessoa com permissão de escrita pode enviar commits direto para a `main`, mesclar PR com o CI vermelho ou dar `push --force`. Os rulesets transformam o combinado do time em regra que o próprio GitHub aplica. Eles ficam em Settings, na seção Rules, e substituem as antigas regras de proteção de branch (branch protection rules), que ainda existem e funcionam.

| Regra (nome na interface) | O que exige |
| --- | --- |
| Require a pull request before merging | Toda mudança entra por PR, com um número mínimo de aprovações |
| Require status checks to pass | Os checks escolhidos precisam estar verdes para liberar o merge |
| Block force pushes | Recusa `push --force` |
| Restrict deletions | Ninguém apaga a branch |
| Require linear history | Proíbe commit de merge, para quem usa só squash ou rebase |

Uma configuração sugerida para começar, numa `main` de projeto pequeno, é exigir PR, exigir o check do CI, bloquear force push e restringir exclusão. A prática deste repositório mostra como ligar o check como obrigatório.

> [!WARNING]
> Se o ruleset exigir uma aprovação e você for a única pessoa no repositório, o merge trava, porque o GitHub não deixa o autor aprovar o próprio PR. Em repositório pessoal, deixe o número de aprovações em zero e mantenha só o check obrigatório, ou convide alguém para revisar.

Rulesets e proteção de branch dependem do plano. Em repositório público eles costumam estar disponíveis no plano gratuito, e em repositório privado podem exigir plano pago. Como isso muda com o tempo, confira na documentação do GitHub antes de contar com o recurso num repositório privado.

## Arquivos que o GitHub reconhece

Alguns arquivos com nomes especiais aparecem em lugares de destaque.

| Arquivo | Para que serve |
| --- | --- |
| `README.md` | A capa do repositório |
| `LICENSE` | Diz o que outras pessoas podem fazer com o conteúdo. Sem licença, ninguém tem permissão legal de reutilizar |
| `CONTRIBUTING.md` | Como contribuir |
| `SECURITY.md` | Como reportar uma vulnerabilidade sem abrir issue pública |
| `.github/pull_request_template.md` | Texto inicial de todo PR |
| `.github/workflows/*.yml` | Os workflows do GitHub Actions |

## Segredo não mora no repositório

Senha, token e chave de API nunca entram no Git. O histórico guarda tudo, e um segredo commitado e apagado no commit seguinte continua legível para quem clonar. Cada contexto tem o lugar certo para o segredo.

| Contexto | Lugar certo |
| --- | --- |
| Sua máquina | Arquivo `.env` listado no `.gitignore` |
| GitHub Actions | Secrets do repositório ou do ambiente, usados como `${{ secrets.NOME }}` |
| Exemplo para o time | Um `.env.example` versionado, com as chaves e valores falsos |

Se um segredo vazar, a ordem importa. Primeiro revogue e troque o segredo, depois remova do código e só então avalie limpar o histórico. Limpar o histórico de um segredo que ainda funciona é trancar a porta depois que a chave já foi copiada.

## Exercícios

1. Qual a diferença prática entre `git fetch` e `git pull`?
2. Seu push foi recusado com `fetch first`. Por que `git push --force` é a resposta errada?
3. Por que a prática recomenda template em vez de fork?

<details>
<summary>Respostas</summary>

1. O `fetch` só atualiza a fotografia do remoto e não mexe nos seus arquivos. O `pull` faz o `fetch` e em seguida integra as novidades na sua branch.
2. Porque o `--force` substitui a branch remota pela sua, apagando os commits que o colega enviou. O certo é `git pull --rebase` e depois `git push`.
3. Porque o repositório criado por template é independente desde o início, com os workflows funcionando e com os PRs ficando dentro dele. No fork, os workflows começam desligados e o PR aponta por padrão para o repositório original.

</details>

Próximo arquivo, [04. GitHub Actions, os conceitos](04-github-actions-conceitos.md).
