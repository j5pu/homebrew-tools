#!/usr/bin/env bash
# bashsupport disable=BP5001
#
# test.sh - Test
#
# test.sh  - Test all formulas except exclude.
# test.sh --all - Test all formulas except exclude, afterwards run all brew tests.
# test.sh name1 name2 - Test formulas from args.
# test.sh name1 --all name2 - Test formulas from args, afterward run all brew tests.

export exclude="^a-file-icon-idea$|^g$|^icons-mac$|^paper$|^scripts$"

brew() { /usr/local/bin/brew "${@}"; }

all() {
  echo AQUIIIIIII
  brew test-bot --quiet --only-cleanup-before "${1}"
  brew test-bot --quiet --only-setup "${1}"
  brew test-bot --quiet --only-tap-syntax "${1}"
  brew test-bot --quiet --only-formulae "${1}"
}

run() {
  if brew audit --quiet --new "${1}"; then
    # TODO: Docker !!! y pre-commit y ubuntu.
    if brew install --quiet j5pu/tools/"${1}"; then
      brew test --quiet "${1}"
    fi
  fi
}

main() {
  local basename filename files i name path
  filename="${0##*/}"
  path="${0%${filename}}"
  (
    cd "${path}"/.. || exit 1
    if [[ $# -eq 0 ]] || [[ $# -eq 1 && $all ]]; then
      files=( ./Casks/*.rb ./Formula/*.rb )
    else
      files=( "${@}" )
      exclude='^--all$'
    fi
    for i in "${files[@]}"; do
      basename=${i##*/}
      name="${basename%.*}"
      if ! [[ "${name}" =~ ${exclude} ]]; then
        run "${name}" || exit 1
      fi
    done
    # TODO: commit all before running all.
    if $all; then
      all "${name}"
    fi
  )
}

for i; do
  case "${i}" in
    --all) all=true
  esac
done

main "${@}"
