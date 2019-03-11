# Informacoes principais
JOB_NAME="setup_ethereum_env"
USER_HOME="$HOME"

# configuracao das portas
PORT="30304"
RPC_PORT="8546"
CACHE=2048

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
	
	folders=("${USER_HOME}/ethereum-workspace")
	
	for folder in "${folders[@]}"
	do
		check_and_create_folder "$folder"
	done

}

install_package() {

	local package="$1"
	
	apt-get install "$package"
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

	repositories=("ethereum")
	packages=("ethereum" "software-properties-common")
	
	for repository in "${repositories[@]}"
	do
		add_apt_repository "$repository"
	done
	
	apt update
	
	for package in "${packages[@]}"
	do
		install_package "$package"
	done

}

create_ethereum_network() {

	geth --rinkeby --datadir=~/.gophersland_ethereum_r1 \
	--port="$PORT" --cache="$CACHE" --rpc --rpcport="$RPC_PORT" \
	--rpcapi=eth,web3,net,personal --syncmode=fast

}


main() {

	check_and_create_folders
	install_necessary_packages
	create_ethereum_network

}


main
