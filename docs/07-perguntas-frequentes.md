# 07. Perguntas frequentes

As dúvidas que mais aparecem em minicursos de Git e Actions, com respostas curtas e o arquivo do guia onde está a explicação longa.

## Git e GitHub

**Git e GitHub são a mesma coisa?**
Não. O Git é o programa que versiona na sua máquina. O GitHub é um serviço que hospeda repositórios Git e acrescenta colaboração. Dá para usar Git sem GitHub, mas não o contrário. Veja [01. Fundamentos de Git](01-fundamentos-de-git.md).

**Qual a diferença entre commit e push?**
O commit grava uma foto do projeto no seu repositório local. O push envia para o remoto os commits que ele ainda não tem. Commitar sem dar push é como salvar o arquivo no computador e não mandar para ninguém.

**O Git funciona sem internet?**
Quase tudo funciona. Commit, branch, merge, log e diff são locais. Só a troca com o remoto (`fetch`, `pull`, `push`) e os recursos do GitHub precisam de rede.

**Preciso usar o terminal? A interface do editor não resolve?**
A interface resolve o dia a dia, e não há problema em usá-la. Mas os botões chamam os comandos do Git por baixo, e quando algo dá errado a mensagem de erro é do Git. Entender os comandos é o que permite sair de um conflito sem pânico.

**Por que main e não master?**
O GitHub passou a usar `main` como nome padrão da branch inicial em repositórios novos. Tecnicamente o nome não muda nada. O importante é o time combinar e configurar `init.defaultBranch` para que o local e o remoto usem o mesmo nome.

**Com que frequência devo commitar?**
Sempre que completar uma unidade de trabalho que faz sentido sozinha. Pode ser a cada 15 minutos ou a cada duas horas. Um commit por dia com tudo misturado é o hábito mais difícil de corrigir depois.

**Merge ou rebase?**
Nenhum é melhor em geral. O rebase deixa a história linear e é ótimo para atualizar a sua própria branch antes do PR. O merge preserva a história como ela aconteceu e é o seguro em branch compartilhada. Veja [02. Branches, PR e merge](02-branches-pr-e-merge.md).

**Conflito significa que alguém errou?**
Não. Significa que duas pessoas mudaram o mesmo trecho de formas diferentes, e o Git não quer adivinhar qual vale. Conflito frequente e grande, esse sim, é sinal de que as branches ficam separadas por tempo demais.

## Erros e recuperação

**Fiz reset e perdi tudo. Tem volta?**
Quase sempre. Se o trabalho chegou a ser commitado, o `git reflog` mostra onde a branch estava antes, e `git reset --hard HEAD@{n}` volta para lá. Só não volta o que nunca foi commitado. A [lista de comandos](comandos-git.md) tem o passo a passo.

**Dei push de algo errado. Consigo apagar do GitHub?**
Se a branch é só sua, dá para reescrever e enviar com `git push --force-with-lease`. Se é compartilhada, use `git revert`, que desfaz criando um commit novo. Se for um segredo, troque o segredo primeiro, porque apagar não desfaz o vazamento.

**Commitei uma senha. Se eu apagar o arquivo e commitar de novo, resolve?**
Não. A senha continua nos commits anteriores. O primeiro passo é trocar a senha. Veja [03. GitHub](03-github.md).

## GitHub Actions

**O Actions é pago?**
Em repositório público, os runners padrão do GitHub são gratuitos. Em repositório privado existe uma cota mensal de minutos que depende do plano. Confira os números atuais na documentação do GitHub.

**Meu workflow não apareceu na aba Actions. Por quê?**
As causas mais comuns são três. O arquivo não está em `.github/workflows/` (com o ponto no começo e o nome da pasta no plural), a extensão não é `.yml` nem `.yaml`, ou o YAML tem erro de sintaxe, caso em que a aba Actions costuma mostrar o erro. Em fork, os workflows ficam desligados até alguém habilitar.

**O botão Run workflow não aparece.**
Ele só aparece se o workflow tiver o evento `workflow_dispatch`, se o arquivo estiver na branch padrão do repositório e se você tiver permissão de escrita. Também é preciso clicar no nome do workflow na barra lateral.

**O workflow está há minutos em "Queued". O que fazer?**
Normalmente é fila dos runners do GitHub, e basta esperar. Se demorar demais, confira a página de status do GitHub. Em eventos com muita gente disparando ao mesmo tempo, a fila pode aumentar.

**Posso rodar o workflow na minha máquina antes de enviar?**
O script que o workflow chama, sim. Na prática deste repositório, `bash scripts/check.sh` roda igual no seu terminal e no runner. Existem ferramentas que tentam simular o runner inteiro localmente, mas elas não reproduzem tudo, e o teste definitivo continua sendo no GitHub.

**Qual a diferença entre `pull_request` e `pull_request_target`?**
O primeiro roda com o código do PR e sem segredos quando o PR vem de fork. O segundo roda com o código da branch base, com segredos. Para CI, use sempre `pull_request`. Veja [06. Boas práticas e segurança](06-boas-praticas-e-seguranca.md).

**Por que o CI pegou um erro que o merge não pegaria?**
Porque o Git junta texto. Se a mudança não conflita com nada, o merge passa. Quem sabe que a unidade tem de ser "segundos" é a regra do projeto, e o CI é essa regra escrita em código e executada em todo PR.

**Dá para usar o Actions para outra coisa além de testar código?**
Dá. Publicar sites, gerar relatórios, fechar issues antigas, mandar avisos, atualizar dependências. Qualquer tarefa que se possa escrever como comando e que precise acontecer em resposta a um evento do repositório.

Próximo arquivo, [08. Glossário](08-glossario.md).
