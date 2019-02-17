#!/bin/bash

print_execution_dates() {

	local log_text=("$@")
	local index=${#log_text[@]}
	local count=0
	local is_start=-1
	local start_date
	local start_time
	local end_date
	local end_time
	local date_regex="[0-9]{2}-[0-9]{2}-[0-9]{4}"
	local time_regex="[0-9]{2}:[0-9]{2}:[0-9]{2}"
	
	while (($index > 0 && count != 2))
	do
		
		index=$(($index - 1))
		
		if ((is_start == -1))
		then
			end_date=$(echo "${log_text[$index]}" | grep -Eo "$date_regex")
			end_time=$(echo "${log_text[$index]}" | grep -Eo "$time_regex")
			
			if [ ! -z "$end_date" ] && [ ! -z "$end_time" ]
			then
				is_start=$((-1 * $is_start))
				count=$(($count + 1))
			fi
		elif ((is_start == 1))
		then
			echo "${log_text[$index]}" | grep -E "*------*" > /dev/null
			if [ $? -eq 0 ]
			then
				start_date=$(echo "${log_text[$index]}" | grep -Eo "$date_regex")
				start_time=$(echo "${log_text[$index]}" | grep -Eo "$time_regex")
				
				if [ ! -z "$start_date" ] && [ ! -z "$start_time" ]
				then
					is_start=$((-1 * $is_start))
					count=$(($count + 1))
				fi
			elif (($index == 1))
			then
				start_date=$(echo "${log_text[$index]}" | grep -Eo "$date_regex")
				start_time=$(echo "${log_text[$index]}" | grep -Eo "$time_regex")
				
				if [ ! -z "$start_date" ] && [ ! -z "$start_time" ]
				then
					is_start=$((-1 * $is_start))
					count=$(($count + 1))
				fi
			fi
		fi		
		
	done
	
	local output=("${start_date}-${start_time}")
	output+=("${end_date}-${end_time}")
	echo "${output[@]}"

}

print_execution_dates_propz_customer() {

	local log_text=("$@")
	local log_text_len=${#log_text[@]}
	local index=$(($log_text_len - 1))
	local log_text_second_to_last_line=$(printf "%s\n" "${log_text[@]}" | tail -2 | sed '1q;d')
	local start_date_regex="inicio:\\[.{19}\\]"
	local end_date_regex="fim:\\[.{19}\\]"
	local time_stamp_regex="[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}"
	local start_date
	local end_date
	
	start_date=$(echo $log_text_second_to_last_line | grep -oE "$start_date_regex" | grep -oE "$time_stamp_regex" | sed 's/\s/-/g')
	end_date=$(echo $log_text_second_to_last_line | grep -oE "$end_date_regex" | grep -oE "$time_stamp_regex" | sed 's/\s/-/g')
	
	start_date=$(echo $start_date | sed 's/[-:]/ /g' | awk '{print $3"-"$2"-"$1"-"$4":"$5":"$6}')
	end_date=$(echo $end_date | sed 's/[-:]/ /g' | awk '{print $3"-"$2"-"$1"-"$4":"$5":"$6}')
	
	echo "${start_date} ${end_date}"
	
}

print_log_errors() {
	
	local date_start=$(echo $1 | sed 's/-//g')
	local date_end=$(echo $2 | sed 's/-//g')
	shift; shift
	local log_text=("$@")
	
	local OLDIFS=$IFS
	IFS=$'\n'
	
	local errors=($(printf "%s\n" "${log_text[@]}" | grep -i "ERRO"))
	IFS=$OLDIFS

	echo "Erros:"
	if [ "$errors" != "" ]
	then
		for error in "${errors[@]}"
		do
			
			local error_date=$(echo "$error" | awk '{print $1}' | sed 's/-//g')
			if [ "$error_date" == "${date_start:0:8}" ] || [ "$error_date" == "${date_end:0:8}" ]
			
			then
				echo "$error"
			fi
		done
	else
		echo "Nao houveram erros."
	fi

}

logs() {

	local logs_dir="/gfsdata01/br/com/carrefour/prd/dolphin/queries/logs/"
	local fn_logs_maestro=("ingest_maestro_oracle.log"
							"ingest_maestro_control_spark.log"
							"ingest_maestro_customer_control_spark.log"
							"batch_promotion_arizona.log"
							"batch_propz_promotion_store.log"
							"batch_propz_promotion_c.log"
							"batch_propz_promotion_o.log"
							"batch_propz_promotion_customer.log")
	
	local fn_logs_f_acct_target=("ingest_document_consumer_offer.log")
	local date
	
	echo
	echo "=== MAESTRO ==="
								
	for log in "${fn_logs_maestro[@]}"
	do
		echo
		echo "---------------------------------------------------------------------------------------------"
		echo "Arquivo ${log}"
		
		OLDIFS=$IFS
		IFS=$'\n'
		local log_text=($(cat ${logs_dir}${log}))
		IFS=$OLDIFS
		
		if [ "$log" == "batch_propz_promotion_customer.log" ]
		then
			date=($(print_execution_dates_propz_customer "${log_text[@]}"))
		else
			date=($(print_execution_dates "${log_text[@]}"))			
		fi
		
		print_log_errors "${date[0]}" "${date[1]}" "${log_text[@]}"
		echo "Data de inicio:			${date[0]}"
		echo "Data de termino:		${date[1]}"
		echo
		
		echo "---------------------------------------------------------------------------------------------"
	done
	
	echo
	echo "=== F_ACCT_TARGET ==="
	
	for log in "${fn_logs_f_acct_target[@]}"
	do
		echo
		echo "---------------------------------------------------------------------------------------------"
		echo "Arquivo ${log}"
		
		OLDIFS=$IFS
		IFS=$'\n'
		local log_text=($(cat ${logs_dir}${log}))
		IFS=$OLDIFS
		
		date=($(print_execution_dates "${log_text[@]}"))
		print_log_errors "${date[0]}" "${date[1]}" "${log_text[@]}"
		echo "Data de inicio:			${date[0]}"
		echo "Data de termino:		${date[1]}"
		echo
		
		echo "---------------------------------------------------------------------------------------------"
		
	done

}

execute_phoenix_query() {
	
	local script="$1"
	local output=$(/usr/hdp/current/phoenix-client/bin/sqlline.py ${script})
	local sed_script='s/\^H\?//g; s/\$//g; /(..%)[0-9]/d; s/\[\[1m//g; s/\[\[m//g'
	
	cat -e <(echo "$output") | sed "$sed_script"
	
}

queries_phoenix() {
	
	local arizona_queries=("propz_monitoria_arizona_dth.sql"
							"propz_monitoria_arizona_qtd.sql")				
	local tbl_control_queries=("propz_monitoria_customer_control_dth.sql"
								"propz_monitoria_customer_control_qtd.sql"
								"propz_monitoria_pr_control_dth.sql"
								"propz_monitoria_pr_control_qtd.sql")
	local scripts_home="/home/alpha/scripts_monitoria_teste/"
	
	output+=$'\n'
	output+="=== ARIZONA ==="
	output+=$'\n'
	output+=$'\n'
	for fn_script in "${arizona_queries[@]}"
	do
		output+=$(execute_phoenix_query "${scripts_home}${fn_script}") || return
		output+=$'\n'
		output+=$'\n'
	done
	
	output+=$'\n'
	output+="=== TABELAS DE CONTROLE ==="
	output+=$'\n'
	output+=$'\n'
	output+="Customer Control:"
	output+=$'\n'
	output+=$'\n'
	output+=$(execute_phoenix_query "${scripts_home}${tbl_control_queries[0]}") || return
	output+=$'\n'
	output+=$'\n'
	output+=$(execute_phoenix_query "${scripts_home}${tbl_control_queries[1]}") || return
	output+=$'\n'
	output+=$'\n'
	output+="Promotion Control:"
	output+=$'\n'
	output+=$'\n'
	output+=$(execute_phoenix_query "${scripts_home}${tbl_control_queries[2]}") || return
	output+=$'\n'
	output+=$'\n'
	output+=$(execute_phoenix_query "${scripts_home}${tbl_control_queries[3]}") || return
	output+=$'\n'
	
	echo "$output"

}

print_date() {

	local time_stamp="$1"
	echo "Monitoria Propz ${time_stamp}"

}

main() {
	
	local time_stamp=$(date +"%d-%m-%Y")
	local output_file="/home/alpha/monitoria_propz_${time_stamp}.txt"	
	
	local date=$(print_date "$time_stamp")
	local output_logs=$(logs)
	local exit_status_logs=$?
	local output_phoenix=$(queries_phoenix)
	local exit_status_queries_phoenix=$?
	local output_hdfs_files_check=$(hdfs_files_check)
	
	if [ $exit_status_logs -eq 0 ] && [ $exit_status_queries_phoenix -eq 0 ]
	then
		echo "$date" > "$output_file"
		echo "$output_logs" >> "$output_file"
		echo "$output_phoenix" >> "$output_file"
		echo "$output_hdfs_files_check" >> "$output_file"
		echo "Relatorio gerado em $output_file"
	else
		echo "Erro, relatorio nao gerado."
		return 1
	fi	
	
}

function echo_HDFS_file_last_line(){ #Faz um ls na pasta do HDFS informada e pega a ultima linha 

	local result=$(hdfs dfs -ls "$1" | tail -n 1)
    local output=$(report_content_HDFS "$2" "$result")
	
	echo "$output"
        
}
function report_content_HDFS(){ #Faz o prenchimento do conte�do do Relat�rio da parte do HDFS
	
	local file_hadoop=$(echo "$2" | awk '{print $8}')
	local output
	output+=$'\n'
	output+=$'\n'
	output+=$(echo "ARQUIVO: $1")
	output+=$'\n'
	output+=$(echo "RESULT:  ${file_hadoop##*/}")
	output+=$'\n'
	
	echo "$output"

}

hdfs_files_check() {

	HOME_PATH_HDFS="/br/com/carrefour/dolphin/landing/propz/sent/"
	PROCESSING_NAMES_HDFS=("RETAIL_PROMOTION_CUSTOMER_1320_000_YYYYMMDD_NNNN.gz.parquet" "CRM_CUSTOMER_1100_000_YYYYMMDD.gz.parquet" "RETAIL_PROMOTION_1309_000_YYYYMMDD.gz.parquet" "RETAIL_PROMOTION_STORE_1310_000_YYYYMMDD.gz.parquet" "RETAIL_SKU_1300_000_YYYYMMDD.gz.parquet" "RETAIL_STORE_1306_000_YYYYMMDD.gz.parquet" "RETAIL_TICKET_1301_000_YYYYMMDD_YYYYMMDDHHMISS.gz.parquet" "RETAIL_ITEM_DETAIL_1302_000_YYYYMMDD_YYYYMMDDHHMISS.gz.parquet" "RETAIL_PAYMENT_DETAIL_1303_000_YYYYMMDD_YYYYMMDDHHMISS.gz.parquet")
	PROCESSING_PATH_HDFS=( "${HOME_PATH_HDFS}RETAIL_PROMOTION_CUSTOMER_1320_000_*" "${HOME_PATH_HDFS}CRM_CUSTOMER_1100_000_*" "${HOME_PATH_HDFS}RETAIL_PROMOTION_1309_000_*" "${HOME_PATH_HDFS}RETAIL_PROMOTION_STORE_1310_000_*" "${HOME_PATH_HDFS}RETAIL_SKU_1300_000_*" "${HOME_PATH_HDFS}RETAIL_STORE_1306_000_*" "${HOME_PATH_HDFS}RETAIL_TICKET_1301_000_*" "${HOME_PATH_HDFS}RETAIL_ITEM_DETAIL_1302_000_*" "${HOME_PATH_HDFS}RETAIL_PAYMENT_DETAIL_1303_000_*")
	NUM_ARRAY=${#PROCESSING_PATH_HDFS[@]} 

	local output+=$'\n'
	output+=$'\n'
	output+=$(printf "=== BUSCAR O ULTIMO ARQUIVO ===\n\n")
	for((i=0;i<$NUM_ARRAY;i++)) do
        output+=$(echo_HDFS_file_last_line "${PROCESSING_PATH_HDFS[$i]}" "${PROCESSING_NAMES_HDFS[$i]}")
		output+=$'\n'
    done
	
	echo "$output"

}

main
exit $?