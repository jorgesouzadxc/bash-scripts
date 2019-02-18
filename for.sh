main() {

  echo "for de 1 a 10"
  for i in $(seq 1 10)
  do
    echo $i
  done

  echo "Ou com contexto aritmético"
  for ((i=1; i<=10; i++))
  do
    echo $i
  done

  echo "for in array"
  array=("elem1" "elem2" "elem3")
  echo "${array[@]}"
  for i in "${array[@]}"
  do
    echo "$i"
  done

}

main
