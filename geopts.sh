#!/usr/bin/env bash

function usage() {
  echo "Usage: $0 [-i] [-v*] [-h] [-f FILENAME] [-t TIMES] <word>"
}

VERBOSE=0
INTERACTIVE=  
FILENAME=memo.txt
TIMES=1

while getopts "ivhf:t:" opt; do
  case "$opt" in
  i) INTERACTIVE=1;;
  v) (( VERBOSE++ ));;
  h) usage && exit 0;;
  f) FILENAME="$OPTARG";;
  t) TIMES="$OPTARG";;
  esac
done
echo $OPTIND
shift $(( OPTIND - 1 ))

name=${1:?$( usage )}
	
if [[ "$TIMES" -le 0 ]]; then
  echo "TIMES must be a positive integer." >&2
  exit 1
fi

if [[ -n "$INTERACTIVE" ]]; then
  echo "Are you sure you want to party?"
  read -r -p"[yn] " answer
  if [[ "$answer" != y ]]; then
    echo "Exiting."
    exit 0
  fi
fi

printf "We are being "
for (( i=0; i<VERBOSE; i++ )); do
  printf "very "
done
printf "verbose.\n"

for (( i=0; i<TIMES; i++ )); do
  echo "Hello, $name!" >> $FILENAME
done

echo "Complete!"
exit 0