# Rulesets

Regras de plataforma versionadas como código.

| Arquivo | Alvo | Estado hoje |
| :--- | :--- | :--- |
| `org-repo-naming.json` | Organização | **Aplicado** nos repositórios públicos |
| `org-branch-protection.json` | Organização | **Aplicado** nos repositórios públicos |
| `repo-github-default.json` | Repositório `.github` | **Aplicado** |

No plano Free, rulesets de organização não alcançam repositórios privados. Como aqui os
repositórios nascem públicos, as regras valem hoje — ao contrário da organização técnica,
onde os equivalentes estão dormentes até o upgrade para o plano Team.

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
./rulesets/apply-org.sh                                    # rulesets de organização
gh api -X POST repos/c4u-edu/.github/rulesets \
  --input rulesets/repo-github-default.json                # ruleset deste repositório
```

## Testar

```bash
./scripts/test-naming.sh
```
