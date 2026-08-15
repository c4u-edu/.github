# 🎓 Hub de Governança — Coding4u Educação

Este repositório (`.github`) centraliza as normas, políticas de comunidade e templates
compartilhados da organização **c4u-edu**, onde vivem cursos, workshops, palestras,
eventos e materiais educacionais da Coding4u.

Os *default community health files* definidos aqui são aplicados automaticamente aos
repositórios da organização que não possuem arquivo equivalente próprio. Para que isso
funcione, **este repositório precisa permanecer público**.

Padronizamos **nomenclatura e metadados**. Fora disso, o padrão é liberdade — material
educacional tem formas demais para caber em uma estrutura única.

---

## 📂 Mapeamento do Repositório

| Diretório / Arquivo | Descrição |
| :--- | :--- |
| 📁 [profile/](profile/) | Contém o [profile/README.md](profile/README.md) exibido na home da organização. |
| 📁 [ISSUE_TEMPLATE/](ISSUE_TEMPLATE/) | Formulários para propor entregas, tirar dúvidas e reportar erros em material. |
| 📜 [.github/pull_request_template.md](.github/pull_request_template.md) | Template padrão de Pull Request. |
| 📁 [.github/workflows/](.github/workflows/) | Workflow de CI que roda os scripts de teste. |
| 📁 [rulesets/](rulesets/) | Regras de plataforma versionadas como código. |
| 📁 [properties/](properties/) | Custom properties da organização. |
| 📁 [scripts/](scripts/) | Testes das normas: nomenclatura, metadados, links e sincronismo. |
| 📜 [CONTRIBUTING.md](CONTRIBUTING.md) | As normas: nomenclatura, metadados, visibilidade, branches, licenciamento. |
| 📜 [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) | Código de conduta. |
| 📜 [SECURITY.md](SECURITY.md) | Reporte responsável de falhas de segurança. |
| 📜 [SUPPORT.md](SUPPORT.md) | Canais de suporte. |
| 📜 [CODEOWNERS](CODEOWNERS) | Donos das normas, por caminho. |

---

## 📐 Como as regras se aplicam

Repositórios desta organização nascem **públicos** — material educacional existe para
circular, e repositório aberto dispensa gerenciar convite de aluno um a um.

A nomenclatura vale hoje **por convenção**; a CI deste repositório garante apenas que a
regra publicada aqui e o ruleset em [rulesets/](rulesets/) não divirjam, não que os nomes
reais de repositório a sigam. Rulesets de organização exigem o plano Team, então o
bloqueio na criação só passa a valer no dia do upgrade — os arquivos já estão versionados,
prontos para isso.

Antes de criar um repositório, leia a seção de
[nomenclatura](CONTRIBUTING.md#nomenclatura-de-repositórios).

Se um repositório específico precisar de um template customizado, basta criar um arquivo
com o mesmo nome na pasta `.github/` local dele para sobrescrever a regra global.
