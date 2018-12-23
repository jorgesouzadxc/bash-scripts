
#!/bin/bash

# Trabalhando com números

function main {

  echo Digite numeros
  read numArr

  for num in $numArr
  do
    echo $num
  done

  echo Fim

}

main
