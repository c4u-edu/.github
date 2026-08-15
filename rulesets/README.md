# Rulesets

Regras de plataforma versionadas como código.

| Arquivo | Alvo | Estado hoje |
| :--- | :--- | :--- |
| `org-repo-naming.json` | Organização | Dormente — rulesets de organização exigem o plano Team |
| `org-branch-protection.json` | Organização | Dormente — mesmo motivo |
| `repo-github-default.json` | Repositório `.github` | **Aplicado na publicação** — ver nota abaixo |

Rulesets de **organização** exigem o plano Team. Verificado contra a API: `gh api
orgs/c4u-edu/rulesets` responde `403 Upgrade to GitHub Team to enable this feature`,
independentemente de os repositórios serem públicos ou privados. Até o upgrade, a
nomenclatura vale por convenção e pela CI deste repositório.

Rulesets de **repositório** são gratuitos em repositórios públicos. É por isso que
`repo-github-default.json` não depende do upgrade de plano — ele passa a valer assim que
for publicado (veja "Aplicar" abaixo), diferente dos dois rulesets de organização acima.

## Fonte da verdade

O regex de nomenclatura em `org-repo-naming.json` é o original. O `CONTRIBUTING.md` o cita
literalmente, e o workflow `checks.yml` falha se os dois divergirem. Para alterar a regra
de nomenclatura, edite **este arquivo primeiro**.

## Limite conhecido de validação

Os testes em `scripts/` validam os **regexes** contra nomes reais e fictícios. Eles não
validam o **formato JSON** dos rulesets contra o schema da API do GitHub, porque a API não
oferece dry-run. Cada arquivo é validado ao vivo no momento em que é aplicado. Espere
ajustar campos na primeira execução — o conteúdo das regras está correto, o envelope
pode não estar.

## Aplicar

```bash
./rulesets/apply-org.sh                                    # rulesets de organização — só após upgrade para Team
gh api -X POST repos/c4u-edu/.github/rulesets \
  --input rulesets/repo-github-default.json                # ruleset deste repositório — funciona hoje
```

## Testar

```bash
./scripts/test-naming.sh
```
