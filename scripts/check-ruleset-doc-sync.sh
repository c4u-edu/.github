#!/usr/bin/env bash
set -euo pipefail

RULESET="rulesets/org-repo-naming.json"
DOC="CONTRIBUTING.md"
falhas=0

for regra in estrutura proibicoes; do
  padrao=$(jq -r --arg r "$regra" '.rules[] | select(.parameters.name == $r) | .parameters.pattern' "$RULESET")
  if [ -z "$padrao" ]; then
    echo "FALHA: regra '$regra' ausente em $RULESET"
    falhas=$((falhas + 1))
    continue
  fi
  if ! grep -Fq -- "$padrao" "$DOC"; then
    echo "FALHA: o regex '$regra' não aparece literalmente em $DOC"
    echo "       esperado: $padrao"
    falhas=$((falhas + 1))
  fi
done

[ "$falhas" -eq 0 ] || { echo "$falhas divergência(s) entre ruleset e documentação"; exit 1; }
echo "OK: ruleset e CONTRIBUTING.md estão sincronizados"
