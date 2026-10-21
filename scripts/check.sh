#!/usr/bin/env bash
# Confere o arquivo de configuração da prática.
#
# Uso:  bash scripts/check.sh [arquivo]
#       (sem argumento, confere config.txt)
#
# Sai com código 0 quando está tudo certo e com código 1 quando encontra erro.
# É esse código de saída que deixa o check verde ou vermelho no GitHub Actions.

set -u

arquivo="${1:-config.txt}"
erros=0

# Dentro do GitHub Actions a variável GITHUB_ACTIONS vale "true".
# Lá, uma linha no formato "::error file=...,line=...::mensagem" vira uma
# anotação, que aparece no resumo da execução e na aba de arquivos do PR.
erro() {
  mensagem="$1"
  linha="${2:-}"
  erros=$((erros + 1))
  if [ "${GITHUB_ACTIONS:-}" = "true" ]
  then
    if [ -n "$linha" ]
    then
      echo "::error file=${arquivo},line=${linha}::${mensagem}"
    else
      echo "::error file=${arquivo}::${mensagem}"
    fi
  else
    echo "ERRO  ${mensagem}${linha:+ (linha ${linha})}"
  fi
}

ok() {
  echo "OK    $1"
}

# Devolve o valor da última linha "CHAVE=valor" do arquivo.
# O tr remove o \r que aparece quando o arquivo foi salvo com fim de linha do Windows.
valor_de() {
  tr -d '\r' < "$arquivo" | grep -E "^$1=" | tail -n 1 | cut -d '=' -f 2-
}

# Devolve o número da linha onde a chave aparece (vazio se não aparece).
linha_de() {
  tr -d '\r' < "$arquivo" | grep -nE "^$1=" | tail -n 1 | cut -d ':' -f 1
}

echo "Conferindo ${arquivo}"
echo

if [ ! -f "$arquivo" ]
then
  erro "arquivo ${arquivo} não encontrado"
  exit 1
fi

# Regra 1. PROJETO existe e não tem espaço.
projeto="$(valor_de PROJETO)"
if [ -z "$projeto" ]
then
  erro "a chave PROJETO está faltando ou vazia" "$(linha_de PROJETO)"
else
  case "$projeto" in
    *" "*) erro "PROJETO não pode ter espaço (valor atual: '${projeto}')" "$(linha_de PROJETO)" ;;
    *) ok "PROJETO=${projeto}" ;;
  esac
fi

# Regra 2. TEMPO_LIMITE é um número inteiro entre 1 e 300.
tempo="$(valor_de TEMPO_LIMITE)"
case "$tempo" in
  "")
    erro "a chave TEMPO_LIMITE está faltando ou vazia" "$(linha_de TEMPO_LIMITE)"
    ;;
  *[!0-9]*)
    erro "TEMPO_LIMITE precisa ser um número inteiro (valor atual: '${tempo}')" "$(linha_de TEMPO_LIMITE)"
    ;;
  *)
    if [ "$tempo" -ge 1 ] && [ "$tempo" -le 300 ]
    then
      ok "TEMPO_LIMITE=${tempo}"
    else
      erro "TEMPO_LIMITE precisa ficar entre 1 e 300 (valor atual: ${tempo})" "$(linha_de TEMPO_LIMITE)"
    fi
    ;;
esac

# Regra 3. UNIDADE é "segundos" ou "minutos".
unidade="$(valor_de UNIDADE)"
case "$unidade" in
  segundos | minutos)
    ok "UNIDADE=${unidade}"
    ;;
  "")
    erro "a chave UNIDADE está faltando ou vazia" "$(linha_de UNIDADE)"
    ;;
  *)
    erro "UNIDADE precisa ser 'segundos' ou 'minutos' (valor atual: '${unidade}')" "$(linha_de UNIDADE)"
    ;;
esac

echo
if [ "$erros" -gt 0 ]
then
  echo "Resultado: ${erros} erro(s) encontrado(s). Corrija o ${arquivo} e rode de novo."
  exit 1
fi

echo "Resultado: tudo certo."
exit 0
