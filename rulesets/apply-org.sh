#!/usr/bin/env bash
set -euo pipefail

# Publica os rulesets de ORGANIZAÇÃO.
# Rulesets de organização exigem o plano Team, independentemente de os repositórios serem
# públicos ou privados. Verificado ao vivo contra a API: `gh api orgs/c4u-edu/rulesets`
# responde 403 "Upgrade to GitHub Team to enable this feature." Este arquivo fica
# versionado e pronto para o dia do upgrade.
# O ruleset do próprio .github (repo-github-default.json) NÃO é publicado aqui —
# ele é de repositório, e é aplicado na Task 8 do plano de implementação.

ORG="${ORG:-c4u-edu}"

plano=$(gh api "orgs/$ORG" --jq '.plan.name')
if [ "$plano" = "free" ]; then
  echo "ERRO: a organização $ORG está no plano 'free'." >&2
  echo "Rulesets de organização exigem o plano Team — não há como publicá-los agora." >&2
  echo "Até o upgrade, a nomenclatura vale por convenção e pela CI deste repositório." >&2
  exit 1
fi

for arquivo in rulesets/org-repo-naming.json rulesets/org-branch-protection.json; do
  nome=$(jq -r '.name' "$arquivo")
  echo "==> publicando '$nome' a partir de $arquivo"
  gh api -X POST "orgs/$ORG/rulesets" --input "$arquivo"
done

echo "OK: rulesets de organização publicados"
