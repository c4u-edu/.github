#!/usr/bin/env bash
set -euo pipefail

RULESET="rulesets/org-repo-naming.json"

ESTRUTURA=$(jq -r '.rules[] | select(.parameters.name == "estrutura") | .parameters.pattern' "$RULESET")
PROIBICOES=$(jq -r '.rules[] | select(.parameters.name == "proibicoes") | .parameters.pattern' "$RULESET")

[ -n "$ESTRUTURA" ] || { echo "FALHA: regex 'estrutura' ausente em $RULESET"; exit 1; }
[ -n "$PROIBICOES" ] || { echo "FALHA: regex 'proibicoes' ausente em $RULESET"; exit 1; }

# Nomes fictícios de propósito. Este repositório é público: usar os nomes reais das
# entregas para clientes como fixture publicaria a carteira. Os contextos `acme`,
# `beta` e `tdc` são inventados.
#
# A lista cobre, deliberadamente:
#   - ao menos um exemplo de cada um dos cinco formatos autorizados;
#   - tema de segmento único (go) e tema composto (arquitetura-de-software);
#   - entrega sem edição, com edição de ano e com edição de ano mais sequência.
VALIDOS=(
  c4u-go-workshop
  c4u-ia-generativa-palestra
  c4u-slides-material
  c4u-devday-evento-2026
  acme-kubernetes-curso-2026-1
  acme-kubernetes-curso-2026-2
  beta-arquitetura-de-software-curso
  tdc-clean-code-palestra
  c4u-python-para-dados-workshop-2026
)

# Cobre, deliberadamente:
#   - formatos que parecem plausíveis e não estão autorizados (treinamento,
#     hackathon, mentoria), que é o erro mais provável de quem cria um repositório;
#   - segmentos de menos;
#   - todos os sufixos proibidos, incluindo -final e -copia;
#   - maiúsculas, sublinhado e os sete prefixos de ambiente proibidos;
#   - edição malformada (mês onde só cabe sequência de 1 a 9, ano de dois dígitos,
#     sequência 0 — fora de `[1-9]`, o off-by-one clássico);
#   - tema ausente (contexto + formato + edição, sem o segmento livre do meio);
#   - qualificador depois do formato, e formato pluralizado.
INVALIDOS=(
  c4u-go-treinamento c4u-go-hackathon c4u-go-mentoria
  workshop-go c4u-workshop
  c4u-go-workshop-final c4u-go-workshop-copia c4u-go-workshop-v2
  c4u-go-workshop-old c4u-go-workshop-new c4u-go-workshop-bkp c4u-go-workshop-backup
  C4U-Go-Workshop c4u_go_workshop
  dev-go-workshop test-go-workshop qa-go-workshop hml-go-workshop
  stg-go-workshop prd-go-workshop prod-go-workshop
  c4u-go-workshop-2026-10 c4u-go-workshop-26 c4u-go-workshop-2026-0
  acme-curso-2026
  c4u-go-workshop-avancado
  c4u-go-workshops
)

falhas=0

for nome in "${VALIDOS[@]}"; do
  if ! printf '%s' "$nome" | grep -Eq "$ESTRUTURA" || printf '%s' "$nome" | grep -Eq "$PROIBICOES"; then
    echo "FALHA: '$nome' deveria ser válido e foi rejeitado"
    falhas=$((falhas + 1))
  fi
done

for nome in "${INVALIDOS[@]}"; do
  if printf '%s' "$nome" | grep -Eq "$ESTRUTURA" && ! printf '%s' "$nome" | grep -Eq "$PROIBICOES"; then
    echo "FALHA: '$nome' deveria ser inválido e foi aceito"
    falhas=$((falhas + 1))
  fi
done

if [ "$falhas" -gt 0 ]; then
  echo "$falhas caso(s) falharam"
  exit 1
fi

for arquivo in rulesets/org-repo-naming.json rulesets/org-branch-protection.json rulesets/repo-github-default.json; do
  if ! jq -e '.name and .target and .enforcement and (.rules | length > 0)' "$arquivo" >/dev/null 2>&1; then
    echo "FALHA: $arquivo não tem name, target, enforcement e rules"
    falhas=$((falhas + 1))
  fi
done

if [ "$falhas" -gt 0 ]; then
  echo "$falhas caso(s) falharam"
  exit 1
fi

echo "OK: ${#VALIDOS[@]} válidos e ${#INVALIDOS[@]} inválidos classificados corretamente"
