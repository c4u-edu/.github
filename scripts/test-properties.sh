#!/usr/bin/env bash
set -euo pipefail

SCHEMA="properties/schema.json"
RULESET="rulesets/org-repo-naming.json"
falhas=0

# A extração pega o único grupo de alternativas puramente alfabético do regex — o dos
# formatos. Os demais grupos contêm colchetes ou dígitos e não casam.
# Diferente da organização técnica, o regex daqui NÃO termina no grupo de sufixos: o
# sufixo opcional de edição vem depois. Por isso a extração é por grupo, não por âncora.
sufixos_regex=$(jq -r '.rules[] | select(.parameters.name=="estrutura") | .parameters.pattern' "$RULESET" \
  | grep -oE '\(([a-z]+\|)+[a-z]+\)' | tr -d '()' | tr '|' '\n' | sort || true)

sufixos_schema=$(jq -r '.[] | select(.property_name=="formato") | .allowed_values[]' "$SCHEMA" | sort)

if [ -z "$sufixos_regex" ]; then
  echo "FALHA: não foi possível extrair os formatos do regex 'estrutura' em $RULESET"
  falhas=$((falhas + 1))
fi

if [ -z "$sufixos_schema" ]; then
  echo "FALHA: não foi possível extrair allowed_values de 'formato' em $SCHEMA"
  falhas=$((falhas + 1))
fi

if [ "$sufixos_regex" != "$sufixos_schema" ]; then
  echo "FALHA: allowed_values de 'formato' diverge dos sufixos do regex"
  echo "--- regex ---"; echo "$sufixos_regex"
  echo "--- schema ---"; echo "$sufixos_schema"
  falhas=$((falhas + 1))
fi

if ! jq -e '[.[] | .property_name] | index("contexto")' "$SCHEMA" >/dev/null; then
  echo "FALHA: propriedade 'contexto' ausente"
  falhas=$((falhas + 1))
fi

[ "$falhas" -eq 0 ] || exit 1
echo "OK: schema de custom properties consistente com o regex"
