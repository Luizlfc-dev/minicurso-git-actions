# Plano B do apresentador

Este arquivo é para quem vai conduzir a prática ao vivo. Ele reúne a preparação que evita a maior parte dos problemas e o que fazer quando algo dá errado mesmo assim. A regra de ouro é ter tudo rodado pelo menos uma vez antes do evento, porque assim sempre existe um resultado pronto para mostrar.

## Na véspera

- [ ] Marcar este repositório como template, em **Settings**, **General**, opção **Template repository**. Sem isso, o botão **Use this template** não aparece para a turma
- [ ] Criar uma cópia de ensaio a partir do template, numa conta sua, e fazer os três exercícios do começo ao fim, cronometrando
- [ ] Deixar nessa cópia de ensaio pelo menos uma execução verde e uma vermelha de cada workflow, e um PR mesclado. Elas viram o material do plano B
- [ ] Tirar capturas de tela da aba Actions, de um log com erro, do PR com X vermelho, do PR com check verde e da seção Artifacts
- [ ] Testar o ruleset do fechamento na cópia de ensaio, com zero aprovações
- [ ] Conferir se os nomes de botões e menus citados na prática continuam os mesmos. O GitHub muda a interface de tempos em tempos
- [ ] Confirmar com a organização do evento se haverá internet para a turma, e se a rede bloqueia o github.com
- [ ] Rodar `git --version` e, se for usar, `gh auth status` na máquina da apresentação
- [ ] Aumentar a fonte do terminal e do navegador, fechar abas pessoais e desligar notificações
- [ ] Conferir que nenhum token ou dado pessoal aparece no histórico do terminal que vai ser projetado

## No dia, antes de começar

- [ ] Abrir a cópia de ensaio numa aba e o repositório original em outra
- [ ] Abrir a página de status do GitHub numa aba, para consultar rápido se algo travar
- [ ] Rodar `bash scripts/check.sh` no terminal uma vez, para ter a saída pronta
- [ ] Deixar o link do repositório escrito em letra grande num slide ou no quadro

## Se a internet cair

O Git funciona sem rede. O que para é tudo que depende do GitHub, ou seja, push, PR e Actions. Há três saídas, da mais completa para a mais simples.

1. **Mostrar o script local.** O CI só roda `bash scripts/check.sh`, e isso funciona igual no terminal. Mostre o cenário que passa, quebre o `config.txt`, mostre o erro e corrija. A ideia central do CI, um comando que sai com erro quando algo está errado, fica clara mesmo sem o GitHub.
2. **Simular o remoto com um repositório local.** Para mostrar push, push recusado e pull entre duas pessoas, um repositório "bare" faz o papel do GitHub.

   ```bash
   mkdir demo && cd demo
   git init --bare -b main remoto.git         # o "GitHub" de mentira
   git clone remoto.git pessoa-a
   git clone remoto.git pessoa-b
   ```

   O clone de um repositório vazio mostra um aviso (`You appear to have cloned an empty repository`), que é esperado. Depois, faça um commit em cada pessoa e envie primeiro pela `pessoa-a`. O `git switch -c main` garante que a branch se chame `main`, qualquer que seja a configuração da máquina.

   ```bash
   cd pessoa-a && git switch -c main
   echo a > a.txt && git add a.txt && git commit -m "docs: a"
   git push origin main                       # aceito
   cd ../pessoa-b && git switch -c main
   echo b > b.txt && git add b.txt && git commit -m "docs: b"
   git push origin main                       # recusado com "fetch first"
   git pull --rebase origin main && git push origin main
   ```

   A recusa com `fetch first` aparece igual à do GitHub.
3. **Usar as capturas de tela.** Para PR, check vermelho, check verde e artifacts, mostre as capturas feitas na véspera.

Se a rede voltar no meio do caminho, retome pelo exercício em que a turma parou. Os workflows não dependem de nada que tenha sido feito antes.

## Se o Actions estiver desligado

| Situação | Sinal | O que fazer |
| --- | --- | --- |
| Participante fez fork | A aba Actions mostra um aviso de que os workflows não rodam no fork | Pedir para ler o aviso e clicar no botão de habilitar |
| Actions desabilitado no repositório | A aba Actions não lista os workflows, ou mostra que está desabilitado | **Settings**, **Actions**, **General**, permitir todas as actions e salvar |
| Workflow específico desabilitado | O workflow aparece com indicação de desabilitado na barra lateral | Clicar nele e escolher **Enable workflow** |
| Conta nova ou com restrição | O workflow não inicia, ou aparece um aviso sobre a conta | Pedir para a pessoa acompanhar a tela de um colega e seguir depois em casa |

Um cuidado extra com fork é o PR. Pela interface, o PR de um fork aponta por padrão para o repositório original. Se alguém abrir o PR do exercício 2 contra o original, você vai receber PRs da turma inteira. Peça para conferir o campo **base repository** antes de criar o PR. Se acontecer, feche os PRs recebidos sem mesclar. Os workflows do original não rodam com segredos em PR de fork, então não há risco para o seu repositório, só bagunça.

## Se a fila do runner demorar

Com muita gente disparando ao mesmo tempo, a execução pode ficar em Queued por um tempo.

1. Espere um ou dois minutos e aproveite para explicar o que vai acontecer. Ler o YAML em voz alta preenche bem esse tempo.
2. Consulte a página de status do GitHub. Se houver incidente no Actions, avise a turma e passe para as capturas de tela.
3. Mostre uma execução já terminada na cópia de ensaio. O log é o mesmo que a turma vai ver quando a fila andar.
4. No exercício 3, o job do Windows costuma começar depois do Linux. Se demorar demais, mostre só o Linux e combine de olhar o Windows no fim.
5. Não peça para todo mundo clicar em Re-run ao mesmo tempo. Isso só aumenta a fila.

## Se o botão Run workflow não aparecer

Três causas cobrem quase todos os casos. A pessoa não clicou no nome do workflow na barra lateral, o arquivo do workflow não está na branch padrão, ou ela está olhando o repositório original em vez da própria cópia, onde não tem permissão de escrita.

## Se alguém não tiver Git instalado

Tudo na prática tem caminho pelo navegador. Para quem quiser um editor mais confortável sem instalar nada, apertar a tecla `.` na página do repositório abre o editor web do GitHub, onde dá para editar vários arquivos e commitar.

## Se o merge travar no fechamento

Quase sempre é o ruleset exigindo uma aprovação num repositório de uma pessoa só. Edite o ruleset e coloque zero em **Required approvals**, ou desative o ruleset mudando **Enforcement status** para **Disabled**.

## Frases que ajudam

- "O CI não sabe nada do projeto. Ele só olha se o comando terminou com erro."
- "O Git juntou o texto sem reclamar. Quem sabe que está errado é a regra do projeto."
- "Cada job roda numa máquina nova, que é jogada fora no fim."
- "Se der problema, o log diz o que aconteceu. A primeira coisa é ler o log."
