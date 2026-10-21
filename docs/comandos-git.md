# Comandos Git mais usados

Folha de consulta com os comandos do dia a dia, agrupados pela situação em que você está. A coluna Risco ajuda a saber quando parar e pensar antes de apertar Enter.

| Risco | Significado |
| --- | --- |
| seguro | Só lê, ou cria algo novo sem apagar nada |
| cuidado | Muda arquivos ou a história local, mas tem volta fácil |
| **PERIGOSO** | Pode apagar trabalho que não foi commitado, ou reescrever história que outras pessoas já têm |
## Configurar (uma vez por computador)

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git --version` | Mostra a versão instalada | `git --version` | seguro |
| `git config --global user.name` | Define o nome que vai nos commits | `git config --global user.name "Seu Nome"` | seguro |
| `git config --global user.email` | Define o e-mail que vai nos commits | `git config --global user.email "voce@exemplo.com"` | seguro |
| `git config --global init.defaultBranch` | Define o nome da branch inicial de repositórios novos | `git config --global init.defaultBranch main` | seguro |
| `git config --global pull.ff only` | Faz o `pull` recusar quando precisaria criar merge, para você escolher o que fazer | `git config --global pull.ff only` | seguro |
| `git config --global core.editor` | Escolhe o editor das mensagens de commit | `git config --global core.editor "code --wait"` | seguro |
| `git config --list --show-origin` | Lista a configuração e de qual arquivo veio cada valor | `git config --list --show-origin` | seguro |

## Começar um repositório

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git init` | Transforma a pasta atual num repositório | `git init -b main` | seguro |
| `git clone` | Baixa um repositório inteiro, com a história | `git clone https://github.com/usuario/projeto.git` | seguro |
| `git clone <url> <pasta>` | Clona com outro nome de pasta | `git clone https://github.com/usuario/projeto.git meu-projeto` | seguro |

## Salvar trabalho (o ciclo do snapshot)

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git status` | Mostra o estado dos arquivos. Rode antes e depois de tudo | `git status -s` | seguro |
| `git add <arquivo>` | Coloca o arquivo na área de preparação | `git add config.txt` | seguro |
| `git add .` | Adiciona tudo que mudou na pasta atual. Confira o `git status` antes | `git add .` | cuidado |
| `git add -p` | Pergunta trecho por trecho o que adicionar | `git add -p README.md` | seguro |
| `git diff` | Mostra o que mudou e ainda não foi adicionado | `git diff` | seguro |
| `git diff --staged` | Mostra o que vai entrar no próximo commit | `git diff --staged` | seguro |
| `git commit -m` | Cria o commit com a mensagem | `git commit -m "feat: adiciona exportação"` | seguro |
| `git commit -am` | Adiciona os arquivos já rastreados e commita de uma vez. Não pega arquivo novo | `git commit -am "fix: corrige cálculo"` | seguro |
| `git commit --amend` | Refaz o último commit (mensagem ou conteúdo). Use só antes do push | `git commit --amend -m "docs: corrige README"` | cuidado |
| `git mv` | Renomeia ou move um arquivo rastreado | `git mv rascunho.txt notas.txt` | seguro |
| `git rm` | Apaga o arquivo e registra a remoção para o próximo commit | `git rm notas.txt` | cuidado |
| `git rm --cached` | Para de rastrear o arquivo, mas mantém ele no disco | `git rm --cached .env` | seguro |

## Branches

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git branch` | Lista as branches locais | `git branch` | seguro |
| `git branch -vv` | Lista com o último commit e a branch remota ligada | `git branch -vv` | seguro |
| `git switch -c` | Cria uma branch e entra nela | `git switch -c feat/exportar-csv` | seguro |
| `git switch` | Troca de branch | `git switch main` | seguro |
| `git switch -` | Volta para a branch anterior | `git switch -` | seguro |
| `git merge` | Junta outra branch na atual | `git merge feat/exportar-csv` | seguro |
| `git merge --no-ff` | Junta sempre criando commit de merge, mesmo quando daria fast-forward | `git merge --no-ff feat/exportar-csv` | seguro |
| `git merge --abort` | Desiste de um merge com conflito e volta ao estado anterior | `git merge --abort` | seguro |
| `git diff --name-only --diff-filter=U` | Lista os arquivos que ainda estão em conflito | `git diff --name-only --diff-filter=U` | seguro |
| `git branch -d` | Apaga uma branch que já foi integrada. Recusa se não foi | `git branch -d feat/exportar-csv` | seguro |
| `git branch -D` | Apaga a branch mesmo sem ter sido integrada | `git branch -D experimento` | **PERIGOSO** |

O `-d` minúsculo protege você.

```console
$ git branch -d experimento
error: the branch 'experimento' is not fully merged
hint: If you are sure you want to delete it, run 'git branch -D experimento'
```

## Trabalhar com o remoto

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git remote -v` | Lista os remotos e seus endereços | `git remote -v` | seguro |
| `git remote add` | Cadastra um remoto | `git remote add origin https://github.com/seu-usuario/projeto.git` | seguro |
| `git remote set-url` | Troca o endereço de um remoto | `git remote set-url origin https://github.com/seu-usuario/outro.git` | seguro |
| `git fetch` | Atualiza a fotografia do remoto sem mexer nos seus arquivos | `git fetch` | seguro |
| `git pull` | Traz e integra as novidades na branch atual | `git pull` | cuidado |
| `git pull --rebase` | Traz as novidades e reaplica seus commits por cima | `git pull --rebase` | cuidado |
| `git push -u origin <branch>` | Envia uma branch nova e liga a local à remota | `git push -u origin feat/exportar-csv` | seguro |
| `git push` | Envia os commits da branch atual | `git push` | seguro |
| `git push origin --delete` | Apaga uma branch no remoto | `git push origin --delete feat/exportar-csv` | cuidado |
| `git push --force-with-lease` | Força o envio, mas recusa se alguém mexeu na branch remota desde o seu último `fetch` | `git push --force-with-lease` | cuidado |
| `git push --force` | Substitui a branch remota pela sua, apagando o que os outros enviaram | `git push --force` | **PERIGOSO** |

Quando o push é recusado porque o remoto tem commits que você não tem, a saída é esta.

```console
$ git push
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to '...'
```

A resposta certa é `git pull --rebase` seguido de `git push`. Nunca `--force` numa branch compartilhada.

## Desfazer com segurança

| Quero desfazer | Ainda não enviei | Já enviei |
| --- | --- | --- |
| Uma edição num arquivo | `git restore arquivo` | |
| Um `git add` | `git restore --staged arquivo` | |
| O último commit, mantendo as mudanças nos arquivos | `git reset HEAD~1` | `git revert HEAD` |
| O último commit, jogando as mudanças fora | `git reset --hard HEAD~1` | `git revert HEAD` |
| Um commit qualquer | `git revert <hash>` | `git revert <hash>` |

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git restore <arquivo>` | Descarta as edições não commitadas do arquivo. Não tem volta | `git restore config.txt` | **PERIGOSO** |
| `git restore --staged` | Tira o arquivo da área de preparação, sem perder a edição | `git restore --staged config.txt` | seguro |
| `git revert` | Cria um commit novo que desfaz outro. É o jeito seguro em branch compartilhada | `git revert HEAD` | seguro |
| `git reset HEAD~1` | Desfaz o último commit e deixa as mudanças nos arquivos | `git reset HEAD~1` | cuidado |
| `git reset --hard` | Volta a branch e os arquivos para um commit, apagando o que não foi commitado | `git reset --hard HEAD~1` | **PERIGOSO** |
| `git stash push -m` | Guarda as edições numa gaveta temporária e limpa a pasta | `git stash push -m "trabalho pela metade"` | seguro |
| `git stash list` | Lista o que está guardado | `git stash list` | seguro |
| `git stash pop` | Devolve a última gaveta para os arquivos | `git stash pop` | cuidado |
| `git clean -n` | Mostra quais arquivos não rastreados seriam apagados, sem apagar | `git clean -n` | seguro |
| `git clean -fd` | Apaga de vez os arquivos e pastas não rastreados | `git clean -fd` | **PERIGOSO** |
| `git reflog` | Mostra tudo por onde o `HEAD` passou. É a rede de segurança | `git reflog -5` | seguro |

Rode sempre `git clean -n` antes de `git clean -fd`, para ver a lista.

### O resgate com reflog

Quase tudo que foi commitado continua achável por um bom tempo, mesmo depois de um `reset --hard`.

```console
$ git reset --hard HEAD~1
HEAD is now at 8c4c8ba Revert "feat: algo ruim"
$ git reflog -3
8c4c8ba HEAD@{0}: reset: moving to HEAD~1
b5dd863 HEAD@{1}: commit: wip: local de novo
8c4c8ba HEAD@{2}: reset: moving to HEAD~1
$ git reset --hard "HEAD@{1}"
HEAD is now at b5dd863 wip: local de novo
```

O commit tinha sumido do `git log`, mas o reflog lembrou onde ele estava. O que não volta é o que nunca foi commitado, e por isso `restore`, `reset --hard` e `clean -fd` estão marcados como perigosos.

## Inspecionar a história

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git log --oneline` | Histórico compacto, um commit por linha | `git log --oneline -5` | seguro |
| `git log --oneline --graph --all` | Desenha o mapa das branches | `git log --oneline --graph --all` | seguro |
| `git log -p` | Histórico com o diff de cada commit | `git log -p -1 -- config.txt` | seguro |
| `git log <base>..<branch>` | Commits que estão na branch e não na base | `git log --oneline main..feat/exportar-csv` | seguro |
| `git log -S` | Commits que adicionaram ou removeram um texto | `git log -S "TEMPO_LIMITE=90" --oneline` | seguro |
| `git log --author` | Commits de uma pessoa | `git log --oneline --author="Seu Nome"` | seguro |
| `git show` | Mostra um commit, com mensagem e diff | `git show --stat HEAD` | seguro |
| `git show <ref>:<arquivo>` | Mostra um arquivo como ele era num commit | `git show HEAD~1:config.txt` | seguro |
| `git blame` | Mostra quem mexeu por último em cada linha | `git blame config.txt` | seguro |
| `git shortlog -sn` | Conta commits por autor | `git shortlog -sn HEAD` | seguro |

## Versões

| Comando | O que faz | Exemplo | Risco |
| --- | --- | --- | --- |
| `git tag -a` | Cria uma tag anotada, com mensagem | `git tag -a v1.0.0 -m "Versão 1.0.0"` | seguro |
| `git tag -n` | Lista as tags com a mensagem | `git tag -n` | seguro |
| `git push origin <tag>` | Envia uma tag para o remoto | `git push origin v1.0.0` | seguro |
| `git describe` | Diz onde você está em relação à última tag | `git describe` | seguro |

## GitHub CLI (opcional)

Atalhos para o GitHub pelo terminal. Antes do primeiro uso, rode `gh auth login`.

| Comando | O que faz |
| --- | --- |
| `gh auth status` | Mostra se você está autenticado |
| `gh repo clone usuario/projeto` | Clona um repositório |
| `gh pr create --base main --fill` | Abre um PR usando a mensagem do commit como título |
| `gh pr checks --watch` | Acompanha os checks do PR até terminarem |
| `gh pr merge --squash --delete-branch` | Mescla o PR com squash e apaga a branch |
| `gh run list --limit 5` | Lista as últimas execuções do Actions |
| `gh run watch` | Acompanha a execução em andamento |
| `gh run view --log-failed` | Mostra só o log dos steps que falharam |
| `gh workflow run ola-actions.yml -f nome=turma` | Dispara um workflow com `workflow_dispatch` |

## Cinco regras para levar para casa

1. Rode `git status` antes e depois de tudo.
2. Commits pequenos, com mensagem que explica o porquê.
3. Uma branch por tarefa, integrando cedo e com frequência.
4. Nunca reescreva história que já foi enviada para uma branch compartilhada. Nela, use `revert`.
5. Antes de algo arriscado, crie uma branch de backup (`git branch backup/antes-do-merge`). Depois de algo errado, `git reflog`.
