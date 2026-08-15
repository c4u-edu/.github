#!/usr/bin/env bash
set -euo pipefail

falhas=0

# Regra 1: nenhum link file:/// nos documentos versionados.
# A lista de arquivos vem do git, não do filesystem: a regra fala de documentos
# versionados, e só o git sabe quais são.
if git grep -n 'file:///' -- '*.md' ; then
  echo "FALHA: links file:/// encontrados acima"
  falhas=$((falhas + 1))
fi

# Regra 2: arquivos renderizados fora da raiz do repositório só podem usar URL absoluta.
# profile/README.md renderiza em github.com/c4u-edu, onde um link relativo quebra.
# PULL_REQUEST_TEMPLATE renderiza no repositório consumidor.
for arquivo in profile/README.md PULL_REQUEST_TEMPLATE/pull_request_template.md; do
  if [ ! -f "$arquivo" ]; then
    echo "FALHA: $arquivo não existe"
    falhas=$((falhas + 1))
    continue
  fi
  if grep -nE '\]\((\.\.?/|[A-Za-z0-9_-]+\.md)' "$arquivo"; then
    echo "FALHA: $arquivo tem link relativo; use URL absoluta"
    falhas=$((falhas + 1))
  fi
done

# Regra 3: links relativos nos arquivos da raiz precisam apontar para algo que existe.
# Extrai targets com `[^)]+`, remove fragmentos com sed, e descarta o que ficar vazio
# (uma âncora pura como `[x](#secao)` não tem arquivo para verificar).
# O `|| true` é necessário: um arquivo sem nenhum link faz o grep sair com 1, e sob
# `set -e` isso seria confundido com violação.
for arquivo in README.md CONTRIBUTING.md SUPPORT.md SECURITY.md CODE_OF_CONDUCT.md; do
  [ -f "$arquivo" ] || continue
  alvos=$(grep -oE '\]\([^)]+\)' "$arquivo" \
    | sed -E 's/^\]\(//; s/\)$//; s/#.*$//' \
    | grep -v '^https\?://' \
    | grep -v '^mailto:' \
    | grep -v '^$' || true)
  for alvo in $alvos; do
    if [ ! -e "$alvo" ]; then
      echo "FALHA: $arquivo aponta para '$alvo', que não existe"
      falhas=$((falhas + 1))
    fi
  done
done

[ "$falhas" -eq 0 ] || { echo "$falhas regra(s) de link violada(s)"; exit 1; }
echo "OK: links consistentes"
