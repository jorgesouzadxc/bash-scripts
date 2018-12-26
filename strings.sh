#!/bin/bash

main() {
	str="string"
	strlen "$str"
}

strlen() {
	echo "Str length ${#1}"
}

main
