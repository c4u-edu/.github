#!/usr/bin/env bash
set -euo pipefail

ORG="${ORG:-c4u-edu}"

jq -c '.[]' properties/schema.json | while read -r prop; do
  nome=$(printf '%s' "$prop" | jq -r '.property_name')
  corpo=$(printf '%s' "$prop" | jq 'del(.property_name)')
  echo "==> definindo propriedade '$nome'"
  printf '%s' "$corpo" | gh api -X PUT "orgs/$ORG/properties/schema/$nome" --input -
done

echo "OK: custom properties definidas em $ORG"
