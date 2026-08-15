#!/usr/bin/env bash
set -euo pipefail

falhas=0

# Regra 1: nenhum link file:/// nos documentos versionados.
# A lista de arquivos vem do git, não do filesystem: a regra fala de documentos
# versionados, e só o git sabe quais são. `.yml` entra porque um formulário de Issue
# também é documento versionado, e um link file:/// lá é o mesmo erro.
# `git grep` sai com 1 quando não há match e 128 quando falha (repositório corrompido,
# opção inválida). Um `if` ingênuo trata as duas coisas como "sem violação" — o mesmo
# defeito já corrigido nas Regras 2 e 3. Aqui o status é capturado e os três casos são
# distinguidos: match é falha, ausência de match é sucesso, e erro também é falha, porque
# a regra não chegou a rodar.
saida=$(git grep -n 'file:///' -- '*.md' '*.yml') && st=0 || st=$?
if [ "$st" -eq 0 ]; then
  echo "$saida"
  echo "FALHA: links file:/// encontrados acima"
  falhas=$((falhas + 1))
elif [ "$st" -ne 1 ]; then
  echo "FALHA: git grep falhou com status $st — a regra não chegou a rodar"
  falhas=$((falhas + 1))
fi

# Regra 2: arquivos renderizados fora da raiz deste repositório só podem usar URL absoluta.
# profile/README.md renderiza em github.com/c4u-edu; .github/pull_request_template.md
# renderiza no repositório consumidor; SECURITY.md e SUPPORT.md são default community
# health files e renderizam em github.com/c4u-edu/<entrega>/security/policy e afins — em
# qualquer um desses casos um link relativo resolve contra o repositório errado.
# A extração usa o mesmo idioma da Regra 3: pega todo alvo de link e sobra o que não é
# absoluto (http(s), mailto ou âncora pura), em vez de enumerar formas de link relativo —
# um prefixo de diretório como `rulesets/README.md` é relativo e não teria casado com a
# checagem anterior, que só reconhecia `./`, `../` ou `arquivo.md` sem diretório.
for arquivo in profile/README.md .github/pull_request_template.md SECURITY.md SUPPORT.md; do
  if [ ! -f "$arquivo" ]; then
    echo "FALHA: $arquivo não existe"
    falhas=$((falhas + 1))
    continue
  fi
  relativos=$(grep -oE '\]\([^)]+\)' "$arquivo" \
    | sed -E 's/^\]\(//; s/\)$//' \
    | grep -v '^https\?://' \
    | grep -v '^mailto:' \
    | grep -v '^#' || true)
  if [ -n "$relativos" ]; then
    echo "FALHA: $arquivo tem link relativo; use URL absoluta:"
    printf '  %s\n' $relativos
    falhas=$((falhas + 1))
  fi
done

# Regra 3: links relativos nos arquivos que só são vistos na própria URL, neste
# repositório, precisam apontar para algo que existe. SUPPORT.md e SECURITY.md não
# entram aqui — eles renderizam em outros repositórios e a Regra 2 já exige que sejam
# absolutos, o que torna esta checagem de existência local sem sentido para eles.
# Extrai targets com `[^)]+`, remove fragmentos com sed, e descarta o que ficar vazio
# (uma âncora pura como `[x](#secao)` não tem arquivo para verificar).
# O `|| true` é necessário: um arquivo sem nenhum link faz o grep sair com 1, e sob
# `set -e` isso seria confundido com violação.
for arquivo in README.md CONTRIBUTING.md CODE_OF_CONDUCT.md; do
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
