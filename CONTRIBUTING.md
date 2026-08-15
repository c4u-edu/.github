# Normas da Organização Educacional — Coding4u

Uma página. Padronizamos **nomenclatura e metadados**. Fora disso, o padrão é liberdade.

Na organização técnica o rigor protege produção. Aqui ele protege uma coisa só: a
navegabilidade do acervo. Se uma regra não serve para achar material depois, ela não
está neste documento.

## Nomenclatura de repositórios

Um repositório é uma entrega educacional, em uma edição. Repetiu para outra turma, é
outro repositório — o material fica preservado como foi entregue naquela ocasião.

Estrutura: `contexto-tema-formato[-edição]`

* **Contexto:** quem contratou ou hospeda a entrega. `c4u` em iniciativa própria; um
  identificador curto e estável do cliente, parceiro ou evento anfitrião nos demais.
  Uma palestra que damos no TDC é `tdc-...`, porque quem hospeda é o TDC.
* **Tema:** o assunto da entrega. **Livre**, um ou mais segmentos.
* **Formato:** um dos cinco sufixos autorizados.
* **Edição:** `-AAAA` ou `-AAAA-N`, onde `N` é a sequência da edição no ano, de 1 a 9.
  **Opcional** — só aparece quando há repetição. Entrega única não carrega ruído
  temporal. Mês não entra: a granularidade é o ano.

### Os cinco formatos

Definidos pela forma do engajamento, não pelo rótulo de mercado. Um vocabulário nominal
cresce sem fim — treinamento, formação, bootcamp e imersão são a mesma coisa com nomes
diferentes. Cinco termos cobrem o universo e cabem na cabeça de quem cria o repositório.

| Sufixo | É | Use também para |
| :--- | :--- | :--- |
| `curso` | Série de encontros com progressão | treinamento, formação, bootcamp, imersão |
| `workshop` | Mão na massa, sessão curta | hands-on, oficina, lab |
| `palestra` | Exposição, sessão única | talk, keynote, webinar |
| `evento` | Realização com programação múltipla | hackathon, summit, semana, meetup |
| `material` | Conteúdo que não é uma realização | ebook, exercícios, template de slides, artigo |

Na dúvida, esta tabela é a resposta. Um treinamento in-company é um `curso` — o contexto
já diz que foi para um cliente. Um hackathon é um `evento`.

### As regras

O nome precisa casar com:

```
^[a-z0-9]+(-[a-z0-9]+)+-(curso|workshop|palestra|evento|material)(-[0-9]{4}(-[1-9])?)?$
```

E não pode casar com:

```
^(dev|hml|stg|prd|prod|test|qa)-|-(v[0-9]+|old|new|bkp|backup|final|copia)$
```

Ou seja: sem maiúsculas, sem sublinhado, sem prefixo de ambiente, sem sufixo de versão ou
descarte. `-final` e `-copia` são proibidos porque é exatamente assim que material
didático apodrece — o sufixo de edição existe para ocupar esse espaço de forma legível.

Válidos: `c4u-go-workshop`, `acme-kubernetes-curso-2026-1`, `c4u-ia-generativa-palestra`,
`c4u-devday-evento-2026`, `tdc-clean-code-palestra`, `c4u-slides-material`.

Inválidos: `c4u-go-treinamento`, `c4u-go-workshop-final`, `workshop-go`,
`C4U-Go-Workshop`, `dev-go-workshop`.

**Exceção única:** `.github`, repositório especial do GitHub, que não pode ser renomeado.

> A fonte da verdade destes dois regexes é [`rulesets/org-repo-naming.json`](rulesets/org-repo-naming.json).
> Este documento os cita literalmente, e a CI falha se divergirem.

## Metadados

Todo repositório preenche as custom properties da organização:

| Propriedade | Valor |
| :--- | :--- |
| `contexto` | Igual ao primeiro segmento do nome |
| `formato` | Igual ao sufixo do nome |

Não existe propriedade de data nem de situação: o GitHub já expõe data de criação e o
recurso de arquivar.

## Visibilidade

**Público por padrão.** Material educacional existe para circular, e repositório aberto
dispensa gerenciar convite de aluno um a um.

Duas exceções:

* Entrega in-company cujo material contenha contexto, dados ou propriedade intelectual do
  cliente **nasce privada**.
* Entrega ainda não realizada pode nascer privada e abrir na data.

> ⚠️ Como público é o padrão, **antes de commitar verifique que não há credencial, dado de
> aluno ou material sob NDA.** O secret scanning do GitHub cobre parte das credenciais em
> repositórios públicos; não cobre nada do resto.

## O mínimo dentro do repositório

Um arquivo obrigatório: o `README.md`, com um bloco de identidade no topo. Quatro campos,
que respondem o que alguém precisa saber antes de abrir qualquer outra coisa.

```markdown
# Workshop de Go para APIs

| | |
| :--- | :--- |
| **Formato** | workshop |
| **Público** | Time de engenharia da Acme (in-company) |
| **Data** | 2026-03-12 |
| **Instrutor** | Patrick Ferraz |

Breve descrição da entrega...
```

Estrutura de pastas é **sugerida, nunca exigida**: `slides/`, `exercicios/`, `codigo/`,
`recursos/`. Uma palestra tem um PDF; um hackathon tem regulamento e submissões. Exigir a
mesma árvore para os dois é a padronização que faz as pessoas contornarem a norma.

Recomendado: ignore `docs/superpowers/` e `.superpowers/` no `.gitignore`. Cada pessoa usa
o framework de SDD que preferir, e artefato de agente não é material didático.

## Branches e commits

| Item | Regra |
| :--- | :--- |
| Branch default | `main`, única. Não há `dev`/`stg`/`prd` — não há deploy |
| Branches de trabalho | Livres. Push direto em `main` é permitido |
| Pull Request | Recomendado quando há mais de uma pessoa no repositório; nunca obrigatório |
| Commits | Texto livre, em português, no imperativo. Sem Conventional Commits |

`main` é protegida apenas contra deleção e force-push. Nada de revisão obrigatória.

O próprio `.github` é a exceção: por ser governança, exige Pull Request e CI verde.

## O que é automático

A coluna **Vale hoje?** é o estado real, não o desejado.

| Regra | Como falharia | Vale hoje? |
| :--- | :--- | :--- |
| Sincronismo ruleset ↔ documentação | Falha no CI do Pull Request | **Sim**, neste repositório |
| Proteção da branch do `.github` | Bloqueada pelo ruleset de repositório | **Sim** |
| Nome do repositório | Bloqueado na criação pelo ruleset de organização | Não — rulesets de organização exigem o plano Team |
| Proteção de `main` nas entregas | Bloqueada pelo ruleset de organização | Não — mesmo motivo |
| Metadados preenchidos | Apontado em auditoria | Não — auditoria ainda não existe |
| Bloco de identidade no README | — | Não — convenção, sem verificação |

Ou seja: hoje a nomenclatura vale **por convenção**. Os rulesets de organização estão
versionados em [`rulesets/`](rulesets/) e passam a valer no dia do upgrade para o plano
Team — é uma decisão de plano, não de engenharia.
