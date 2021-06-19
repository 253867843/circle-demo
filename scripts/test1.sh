#!/bin/bash

$(docker exec -it jenkins_docker netstat -an | grep 27017)

# 容器名称
CONTAINER=${container_name}
# 端口号
PORT=${port}
# 随机端口开始
START_RANGE=${start_range}
# 随机端口结束
END_RANGE=${end_range}

echo "PORT -> ${PORT}"

# 默认使用8080端口，可环境变量自定义端口
# if [ "${PORT}" == "" ]; then
# 	# 默认使用 8080 端口
# 	NETSTAT=8080
# else
# 	NETSTAT=${PORT}
# fi 
#
# echo "NETSTAT -> ${NETSTAT}"

# 获取端口号被占用的进程id
# lsof -i :27020 | awk '{ print $1 " " $2  }'
# PID=$(/usr/bin/lsof -i :29000 | awk '{ print $1 " " $2  }')
# PID=`/usr/bin/lsof -i :${PORT}`
# CONTAINER_ID=$(docker ps -a | grep ${PORT} | awk '{ print $1 }')
# echo "CONTAINER_ID -> $CONTAINER_ID"

# if [ "${CONTAINER_ID}" != "" ]; then
# 	echo "端口${NETSTAT}占用"
# else
# 	echo "端口${NETSTAT}未被占用"
# fi

if [ ${START_RANGE} -le ${END_RANGE} ]; then
	echo "123" > /dev/null
else 
	echo "error: please check port range"
	exit
fi 

# 判断当前端口是否被占用(没有被占用返回0，被占用返回1)
function Listening () {
	# TCPListeningnum=0
  # UDPListeningnum=0 
  # TCPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "tcp" && $NF == "LISTEN" {print $0}' | wc -l`
  # UDPListeningnum=`netstat -an | grep ":$1 " | awk '$1 == "udp" && $NF == "0.0.0.0:*" {print $0}' | wc -l`
  # (( Listeningnum = TCPListeningnum + UDPListeningnum ))
  # if [ ${Listeningnum} == 0 ]; then
  #   echo "0"
  # else 
 	# 	echo "1"    
  # fi
	CONTAINER_ID=$(docker ps -a | grep ${1} | awk '{ print $1 }')
	printf "CONTAINER_ID -> ${CONTAINER_ID}"
	# if [ ${CONTAINER_ID} == "0" ]; then
  #   echo "0"
  # else 
 	# 	echo "1"    
  # fi
}

# 指定区间随机数
function random_range () {
	# echo "第一个随机数 -> ${1}"
  # echo "第二个随机数 -> ${2}"
	shuf -i ${1}-${2} -n1
}

# 得到随机端口
function get_random_port () {
	# echo "START_RANGE -> ${1}"
  # echo "END_RANGE -> ${2}"
  TEMP1=0
  #RESULT=0 -> 端口号未被占用不进入循环
  #RESULT=1 -> 端口号已被使用，进入循环，随机端口号
	`Listening ${PORT}`
  # while [ `Listening ${PORT}` != 0 ]; 
  # do 
  #   TEMP1=`random_range ${1} ${2}`
  #   # echo "随机数 -> ${TEMP1}"
  #   if [ `Listening ${TEMP1}` == 0 ]; then
  #     PORT=${TEMP1}
  #   fi
  # done 
  # echo "port -> ${PORT}"
}

# echo "-----函数开始执行-----"
# random_range
get_random_port ${START_RANGE} ${END_RANGE}
# echo "-----函数执行完毕-----"
#
# 添加随机端口号区间
#
# 如果端口号被占用了，不是去停止我们的服务，在指定的范围内，随机使用一个端口号给我们容器



