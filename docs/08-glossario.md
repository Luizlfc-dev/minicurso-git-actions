# 08. Glossário

Os termos do minicurso em ordem alfabética, com uma definição curta cada. Termos em inglês ficam em inglês, porque é assim que aparecem na interface e na documentação.

| Termo | Definição |
| --- | --- |
| Action | Passo reutilizável de workflow, publicado num repositório e usado com `uses:` |
| Annotation | Mensagem de erro, aviso ou nota ligada a um arquivo e linha, criada por um workflow |
| Artifact | Arquivo produzido por uma execução e guardado para download ou para outro job |
| Branch | Nome móvel que aponta para um commit, uma linha de trabalho |
| Branch padrão | A branch principal do repositório, normalmente `main`. É nela que o GitHub procura o workflow do botão Run workflow |
| Cache | Arquivos guardados entre execuções para acelerar workflows futuros |
| CD | Entrega contínua ou implantação contínua. Manter o sistema pronto para publicar, ou publicar automaticamente |
| Check | Resultado de um job mostrado no PR, verde quando passou e vermelho quando falhou |
| CI | Integração contínua. Integrar com frequência, com cada mudança conferida automaticamente |
| Clone | Cópia local de um repositório, com toda a história |
| Commit | Foto do projeto num momento, com autor, data, mensagem e ponteiro para a foto anterior |
| Concurrency | Chave do workflow que impede execuções simultâneas do mesmo grupo |
| Conflito | Situação em que o Git não consegue juntar duas mudanças sozinho e pede uma decisão |
| Contexto | Conjunto de dados disponíveis nas expressões, como `github`, `secrets` e `matrix` |
| Diretório de trabalho | Os arquivos como estão agora, no seu editor |
| Evento | O que dispara um workflow, como `push` ou `pull_request` |
| Expressão | Trecho entre `${{ }}` avaliado pelo GitHub antes de o step rodar |
| Fast-forward | Merge em que a branch só avança o ponteiro, sem criar commit de merge |
| Fetch | Atualizar a cópia local das branches remotas, sem mexer nos seus arquivos |
| Fork | Cópia de um repositório inteiro na sua conta, ligada ao original |
| `GITHUB_TOKEN` | Credencial temporária criada para cada execução de workflow |
| HEAD | Marcador de onde você está agora, normalmente a branch atual |
| Issue | Registro de bug, ideia ou tarefa no GitHub |
| Job | Conjunto de steps que roda numa mesma máquina |
| Matrix | Estratégia que roda o mesmo job para várias combinações de valores |
| Merge | Juntar o trabalho de uma branch em outra |
| `origin` | Nome padrão do remoto principal |
| Permissions | Chave que define o que o `GITHUB_TOKEN` pode fazer |
| Pull | `fetch` seguido da integração das novidades na branch atual |
| Pull Request (PR) | Pedido, no GitHub, para juntar uma branch em outra, com revisão e checks |
| Push | Enviar commits locais para o remoto |
| Rebase | Reaplicar commits em cima de outra base, reescrevendo a história local |
| Reflog | Registro local de tudo por onde o `HEAD` passou, usado para recuperar commits |
| Remoto | Outra cópia do repositório, normalmente no GitHub |
| Repositório | A pasta do projeto mais a pasta `.git`, onde mora a história |
| Revert | Desfazer um commit criando outro commit com a mudança oposta |
| Ruleset | Conjunto de regras que o GitHub aplica a branches ou tags |
| Runner | Máquina que executa um job |
| Secret | Valor sensível cadastrado no GitHub e lido no workflow com `secrets.NOME` |
| SHA | Identificador de 40 caracteres calculado a partir do conteúdo de um commit |
| Squash | Juntar vários commits em um só |
| Staging area | Área de preparação, onde fica o que vai entrar no próximo commit |
| Step | Um passo de um job, que é um comando (`run`) ou uma action (`uses`) |
| Tag | Nome fixo para um commit, usado para marcar versões como `v1.0.0` |
| Template | Repositório usado como modelo para criar outros, sem ligação com o original |
| Workflow | Arquivo YAML em `.github/workflows/` que descreve uma automação |
| `workflow_dispatch` | Evento disparado pelo botão Run workflow |
| YAML | Formato de texto usado nos workflows, em que a indentação define a estrutura |

Volte ao [README](../README.md) ou siga para a [prática](../pratica/README.md).
