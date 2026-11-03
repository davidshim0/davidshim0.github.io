#!/bin/bash
# Fails if British spellings or em/en dashes reach the source. Run before any
# build. A reminder in a notes file does not catch these; a grep does.
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

UK='programme|organis(e|ed|ing|ation)|specialis(e|ed|ing|ation)|optimis(e|ed|ing|ation)'
UK+='|utilis(e|ed|ing|ation)|recognis(e|ed|ing)|analys(e|ed|ing)|modelling|modelled'
UK+='|labour|behaviour|colour|favour|flavour|honour|neighbour|rumour'
UK+='|centre|defence|licence|offence|grey|whilst|amongst|artefact|catalogue'
UK+='|fibre|metre|litre|travelled|cancelled|signalling|learnt|practise'
UK+='|aluminium|storey|kerb|tyre|cheque|draught|plough|mould'

FILES=$(git ls-files '*.html' '*.md' '*.markdown' '*.yml' '*.css' 2>/dev/null | grep -v '^_site/')
fail=0

hits=$(grep -nEio "\\b($UK)\\b" $FILES 2>/dev/null)
if [ -n "$hits" ]; then
  echo "British spellings found:"; echo "$hits" | sed 's/^/  /'; fail=1
fi

dashes=$(grep -nP '[\x{2014}\x{2013}]' $FILES 2>/dev/null)
if [ -n "$dashes" ]; then
  echo "Em or en dashes found (use words, commas or &ndash; in dates):"
  echo "$dashes" | cut -c1-110 | sed 's/^/  /'; fail=1
fi

[ $fail -eq 0 ] && echo "style check: clean"
exit $fail
