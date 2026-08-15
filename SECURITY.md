# Política de Segurança — Coding4u Educação

Os repositórios desta organização são majoritariamente **públicos**, o que desloca o risco
de segurança para o conteúdo: uma credencial esquecida em um slide ou em um exercício fica
exposta ao mundo no instante do push.

## Antes de commitar

Verifique que o material não contém:

* Credenciais, tokens ou chaves de API — inclusive em prints de tela e gravações.
* Dados pessoais de alunos ou participantes.
* Material sob NDA, dados ou propriedade intelectual de cliente. Se contiver, a entrega
  **nasce privada**, conforme as
  [normas da organização](https://github.com/c4u-edu/.github/blob/HEAD/CONTRIBUTING.md).

O secret scanning do GitHub é ativo em repositórios públicos e cobre parte das
credenciais. Ele não cobre dado de aluno nem material sob NDA.

## Como reportar uma vulnerabilidade ou exposição

> ⚠️ **Não abra uma Issue pública** para reportar exposição de dados ou credenciais.

1. Envie um e-mail para `security@edu.coding4u.tech`.
2. Inclua o repositório afetado, o arquivo e a natureza da exposição.
3. Confirmamos o recebimento em até **48 horas úteis**.

Se você encontrou uma credencial exposta em nosso material, o reporte é urgente e
agradecemos muito — rotacionamos o segredo antes de limpar o histórico.
