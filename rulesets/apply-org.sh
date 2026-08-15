#!/usr/bin/env bash
set -euo pipefail

# Publica os rulesets de ORGANIZAÇÃO.
# Diferente da organização técnica, este script RODA no plano Free: as regras se aplicam
# aos repositórios públicos, que aqui são o padrão. O aviso abaixo existe para deixar
# explícito o que fica de fora.
# O ruleset do próprio .github (repo-github-default.json) NÃO é publicado aqui —
# ele é de repositório, e é aplicado na Task 8 do plano de implementação.

ORG="${ORG:-c4u-edu}"

plano=$(gh api "orgs/$ORG" --jq '.plan.name')
if [ "$plano" = "free" ]; then
  echo "AVISO: a organização $ORG está no plano 'free'."
  echo "Os rulesets valerão apenas nos repositórios PÚBLICOS."
  echo "Repositórios privados seguem as normas por convenção até o upgrade para Team."
  echo ""
fi

for arquivo in rulesets/org-repo-naming.json rulesets/org-branch-protection.json; do
  nome=$(jq -r '.name' "$arquivo")
  echo "==> publicando '$nome' a partir de $arquivo"
  gh api -X POST "orgs/$ORG/rulesets" --input "$arquivo"
done

echo "OK: rulesets de organização publicados"
