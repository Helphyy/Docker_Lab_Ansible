#!/bin/bash
# Functions part
help(){
echo "
=====Script Auto_Lab=====

### Mahel Brossier ###

23/05/2022 : V2

=========Options=========

- --start_lab / -s

- --end_lab / -e

- --restart_lab / -r
	
- --info_lab / -i

- --connect / -c

=========================
"

}

startNodes() {
	echo "====================="
	echo "Démarage en cours ..."
	echo "====================="
	docker-compose -f ./00_Lab/Vm_Docker/docker-compose.yml up -d
    infosNodes
    if [ "$1" = "--connect" ] || [ "$1" = "-c" ];then
		connectNode
    fi
}

removeNodes(){
	echo "============================="
	echo "Suppression des conteneurs..."
	echo "============================="
    docker-compose -f ./00_Lab/Vm_Docker/docker-compose.yml down
	echo "====================="
	echo "Fin de la suppression"
	echo "====================="
}

infosNodes(){
	echo "=============================="
	echo "Informations des conteneurs : "
	echo "=============================="
    for conteneur in $(docker ps -a | grep _Node | awk '{print $1}');do      
        docker inspect -f '=> {{.Name}} - {{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $conteneur    
	done
	echo ""
}

connectNode(){
	echo "Connection :"
    docker-compose -f ./00_Lab/Vm_Docker/docker-compose.yml exec control_node bash
}


restartNodes(){
	echo "====================="
	echo "Redémarage en cours :"
	echo "====================="
	removeNodes
	startNodes
	if [ "$1" = "--connect" ] || [ "$1" = "-c" ];then
		connectNode
    fi
}

# Option part

#si option --start_lab
if [ "$1" = "--start_lab" ] || [ "$1" = "-s" ];then
	startNodes $2

# si option --end_lab
elif [ "$1" = "--end_lab" ] || [ "$1" = "-e" ];then
	removeNodes

# si option --info_lab
elif [ "$1" = "--info_lab" ] || [ "$1" = "-i" ];then
	infosNodes

# si option --connect
elif [ "$1" = "--connect" ] || [ "$1" = "-c" ];then
	connectNode

# si option --restart_lab
elif [ "$1" = "--restart_lab" ] || [ "$1" = "-r" ];then
	restartNodes $2

# si pas d'option
else
	help
fi

