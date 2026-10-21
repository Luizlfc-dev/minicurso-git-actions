# Minicurso Git, GitHub e GitHub Actions

Material de estudo e prática do minicurso sobre versionamento com Git, colaboração no GitHub e automação com GitHub Actions. O repositório tem duas partes que se completam. A primeira é um guia de estudos curto, dividido em arquivos numerados, que vai do primeiro commit até a leitura de um workflow linha por linha. A segunda é uma prática guiada em que cada participante cria a própria cópia deste repositório e vê, na aba Actions, workflows de verdade rodando, falhando e voltando a passar.

Nada aqui exige instalar linguagem de programação ou ferramenta de build. Os workflows usam só bash e um arquivo de texto, então cada execução termina em poucos segundos e funciona em qualquer conta gratuita do GitHub.

## Para quem é

O material foi pensado para quem está começando. Serve para quem nunca usou Git, para quem já faz `add`, `commit` e `push` sem saber bem o que acontece por baixo, e para quem nunca abriu a aba Actions de um repositório. Quem já tem experiência pode ir direto para a [prática](pratica/README.md) e para o arquivo de [boas práticas e segurança](docs/06-boas-praticas-e-seguranca.md).

## O que você vai conseguir fazer ao final

1. Explicar a diferença entre Git e GitHub em uma frase.
2. Fazer o ciclo básico (alterar, adicionar, commitar, enviar) sabendo o que cada comando faz.
3. Criar uma branch, abrir um Pull Request e entender o que significa o check verde ou vermelho.
4. Ler um arquivo de workflow e dizer quando ele roda, onde roda e o que faz.
5. Disparar um workflow pelo botão, ler os logs e corrigir um CI que falhou.
6. Aplicar os cuidados básicos de segurança em Actions, como permissão mínima e segredo fora do código.

## Pré-requisitos

| Item | Obrigatório? | Observação |
| --- | --- | --- |
| Conta no GitHub | Sim | A gratuita basta. Crie em github.com antes do minicurso |
| Navegador atualizado | Sim | Toda a prática pode ser feita pela interface web |
| Git instalado | Recomendado | Necessário para seguir a prática pelo terminal. Confira com `git --version` |
| Editor de texto | Recomendado | Qualquer um serve. O VS Code tem integração boa com Git |
| GitHub CLI (`gh`) | Opcional | Facilita abrir PR e acompanhar execuções pelo terminal |

Quem não tiver Git instalado consegue fazer todos os exercícios pelo navegador, editando os arquivos direto no GitHub. A prática indica os dois caminhos.

## Mapa do repositório

```text
.
├── README.md                     este arquivo
├── LICENSE                       licença MIT
├── config.txt                    arquivo que o CI confere
├── .gitignore                    o que o Git deve ignorar
├── .gitattributes                fim de linha LF, para o script bash rodar também no Windows
├── .editorconfig                 padrão de formatação para os editores
├── scripts/
│   └── check.sh                  script de verificação usado pelos workflows
├── .github/
│   └── workflows/
│       ├── ola-actions.yml       exercício 1, o primeiro workflow
│       ├── ci.yml                exercício 2, CI que acusa erro no PR
│       └── bonus-matrix.yml      exercício 3 (bônus), matrix e artifact
├── docs/
│   ├── 01-fundamentos-de-git.md
│   ├── 02-branches-pr-e-merge.md
│   ├── 03-github.md
│   ├── 04-github-actions-conceitos.md
│   ├── 05-anatomia-de-um-workflow.md
│   ├── 06-boas-praticas-e-seguranca.md
│   ├── 07-perguntas-frequentes.md
│   ├── 08-glossario.md
│   ├── comandos-git.md           lista dos comandos mais usados
│   └── plano-b-apresentador.md   o que fazer quando algo dá errado ao vivo
└── pratica/
    └── README.md                 roteiro passo a passo da prática
```

## Como seguir

Para estudar, leia o guia na ordem. Cada arquivo leva entre 10 e 20 minutos e termina indicando o próximo.

| Nº | Arquivo | Assunto |
| --- | --- | --- |
| 01 | [Fundamentos de Git](docs/01-fundamentos-de-git.md) | Versionamento, as três áreas, commit, SHA, `.gitignore` |
| 02 | [Branches, PR e merge](docs/02-branches-pr-e-merge.md) | Branch como ponteiro, merge, conflito, Pull Request, fluxos de trabalho |
| 03 | [GitHub](docs/03-github.md) | Remoto, push e pull, fork e template, issues, rulesets |
| 04 | [GitHub Actions, os conceitos](docs/04-github-actions-conceitos.md) | Workflow, evento, job, step, runner, action, secrets, matrix, cache, artifacts |
| 05 | [Anatomia de um workflow](docs/05-anatomia-de-um-workflow.md) | Um YAML comentado linha por linha e como ler o resultado |
| 06 | [Boas práticas e segurança](docs/06-boas-praticas-e-seguranca.md) | Permissões mínimas, versão fixada, `pull_request_target`, segredos |
| 07 | [Perguntas frequentes](docs/07-perguntas-frequentes.md) | As dúvidas que mais aparecem |
| 08 | [Glossário](docs/08-glossario.md) | Os termos do minicurso em uma linha cada |
| | [Comandos Git mais usados](docs/comandos-git.md) | Folha de consulta, agrupada por situação |

Para praticar, siga o [roteiro da prática](pratica/README.md). Ele começa explicando como criar a sua cópia deste repositório e depois guia três exercícios, com o que deve aparecer na tela em cada passo.

Quem vai apresentar o minicurso encontra no [plano B do apresentador](docs/plano-b-apresentador.md) o checklist de preparação e o que fazer se a internet cair, se o Actions estiver desligado ou se a fila do runner demorar.

## Licença

O conteúdo deste repositório está sob a [licença MIT](LICENSE). Você pode copiar, adaptar e usar em outros cursos e eventos, desde que mantenha o aviso de copyright e a licença.
