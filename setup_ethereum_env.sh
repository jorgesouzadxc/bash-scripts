# Informacoes principais
JOB_NAME="setup_ethereum_env"
USER_HOME="$HOME"

# configuracao das portas
NETWORK_ID=77
PORT="30304"
RPC_PORT="8546"
CACHE=2048

# pastas para instalacao
DATA_DIR="${USER_HOME}/ethereum"

# array de pastas
FOLDERS=("$DATA_DIR")

# pacotes que precisam ser instalados
PACKAGES=("ethereum" "software-properties-common")
REPOSITORIES=("ethereum")

# configuracao da conta
ACCOUNT=""
DEFAULT_BALANCE=2000000

write_log() {
	
	msg="$(date +'%d-%m-%Y-%H:%M:%S') $1"
	echo "$msg"
	echo "$msg" >> "${JOB_NAME}.out"
	
}

script_exit() {

	if [[  $1 -eq 0  ]]
	then
		write_log "[INFO] - execucao do script $JOB_NAME finalizada com sucesso."
		exit 0
	else
		write_log "[ERRO] - script finalizado com falhas."
		exit 1
	fi

}

check_and_create_folder() {

	local folder="$1"
	if [[ -d "$folder" ]]
	then
		write_log "[INFO] - pasta $folder ja existe."
	else
		write_log "[INFO] - pasta $folder sera criada."
		
		mkdir "$folder"
		if [[  $? -eq 0  ]]
		then
			write_log "[INFO] - pasta $folder criada com sucesso."
		else
			write_log "[ERRO] - erro ao criar pasta ${folder}."
			script_exit 1
		fi
	fi

}

check_and_create_folders() {
	write_log "[INFO] - Iniciando checagem e criacao de pastas."
	
	for folder in "${FOLDERS[@]}"
	do
		check_and_create_folder "$folder"
	done

}

install_package() {

	local package="$1"
	
	apt-get install -y "$package"
	if [[  $? -eq 0 ]]
	then
		write_log "[INFO] - pacote $package instalado com sucesso."
	else
		write_log "[ERRO] - erro ao instalar pacote ${package}."
		script_exit 1
	fi
	

}

add_apt_repository() {

	local repo="$1"

	sudo add-apt-repository -y ppa:"$repo"
	if [[  $? -eq 0 ]]
	then
		write_log "[INFO] - repositorio $repo adicionado com sucesso."
	else
		write_log "[ERRO] - erro ao adicionar repositorio ${repo}."
		script_exit 1
	fi

}

install_necessary_packages() {

	write_log "[INFO] - iniciando instalacao dos pacotes necessarios."
	
	for repository in "${REPOSITORIES[@]}"
	do
		add_apt_repository "$repository"
	done
	
	apt update
	
	for package in "${PACKAGES[@]}"
	do
		install_package "$package"
	done

}

start_ethereum_node() {

	write_log "[INFO] - Criando rede ethereum."

	geth --rinkeby \
	--datadir="$DATA_DIR" \
	--nodiscover console \
	--unlock $ACCOUNT
	--port="$PORT" --cache="$CACHE" \
	--rpc --rpcport="$RPC_PORT" \
	--networkid "$NETWORK_ID" \
	--rpcapi=eth,web3,net,personal \
	--syncmode=fast
	
	if [[  $? -eq 0  ]]
	then
		write_log "[INFO] - Rede ethereum criada com sucesso."
		write_log "[INFO] - Porta: $PORT Network ID: $NETWORK_ID RPC PORT: $RPC_PORT"
	else
	fi

}

create_ethereum_new_account() {

	write_log "[INFO] - Criando nova conta ethreum."
	
	local output=$(geth --datadir $DATA_DIR account new)
	echo "$output" > "${JOB_NAME}.account"
	if [[  $? -eq 0  ]]
	then
		write_log "[INFO] - Conta criada com sucesso."
		ACCOUNT=$(echo "$output" | grep 'Address' | sed 's/.*{//' | sed 's/}//' )
		if [[ -z $ACCOUNT ]]
		then
			write_log "[INFO] - Erro durante a captura da conta."
			script_exit 1
		else
			write_log "[INFO] - Conta $ACCOUNT capturada com sucesso."
		fi
	else
		write_log "[ERRO] - Erro durante a criacao da conta."
		script_exit 1
	fi

}

generate_genesis_json() {
	
	write_log "[INFO] - Iniciando geracao do arquivo genesis.json"

	base_json='{
		"config":{
			"chainId":%s,
			"homesteadBlock":0,
			"eip155Block":0,
			"eip158Block":0
		},
		"difficulty":"200000",
		"gasLimit":"2100000000",
		"alloc":{
			"%s":{
				"balance":"%s"
			}
		}
	}'
	
	printf "$base_json" $NETWORK_ID $ACCOUNT $DEFAULT_BALANCE > "${DATA_DIR}/genesis.json"
	if [[  $? -eq 0  ]]
	then
		write_log "[INFO] - Arquivo genesis.json gerado em ${DATA_DIR}/generate_genesis_json"
	else
		write_log "[INFO] - Erro durante a geracao do arquivo genesis.json"
		script_exit 1
	fi

}

setup_ethereum_network() {

	write_log "[INFO] - Iniciando criacao da rede ethereum."
	
	geth --datadir=$DATA_DIR init "${DATA_DIR}/genesis.json"
	if [[  $? -eq 0  ]]
	then
		write_log "[INFO]- Rede ethereum criada com sucesso."
	else
		write_log "[ERRO] - Erro durante a criacao da rede ethereum."
		script_exit 1
	fi

}

main() {

	if [[  $EUID -ne 0 ]]
	then
		write_log "[ERRO] - Este escript precisa ser executado como root."
		write_log "[INFO] - usagem: sudo ${JOB_NAME}.sh"
		script_exit 1
	fi
	
	write_log "[INFO] - Inicio da execucao dos script ${JOB_NAME}.sh."

	check_and_create_folders
	install_necessary_packages
	generate_genesis_json
	create_ethereum_new_account
	setup_ethereum_network
	start_ethereum_node

}


main
