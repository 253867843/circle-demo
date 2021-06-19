#!/bin/bash

CONTAINER=${container_name}
PORT=${port}

# 检查容器运行状态
RUNNING=$(docker inspect --format="{{ .State.Running }}" ${CONTAINER}) 
echo "RUNNING is ${RUNNING}"



if [ ! -n ${RUNNING} ];then
	echo "${CONTAINER} does not exist"
  return 1
fi

if [ "${RUNNING}" == "false" ]; then
	echo "${CONTAINER} is not running"
  return 2
else 
	echo "${CONTAINER} is running"
    # 停止容器
    matchingStarted=$(docker ps --filter="name=${CONTAINER}" -q | xargs)
    echo "matchingStarted -> ${matchingStarted}"
    if [ -n ${matchingStarted} ]; then
    	docker stop ${matchingStarted}
    fi 
    
    matching=$(docker ps -a --filter="name=${CONTAINER}" -q | xargs)
    # 删除容器
    echo "matching -> ${matching}"
    if [ -n ${matching} ];then
    	docker rm ${matching}
    fi 
fi 

# 完成了镜像的构建
docker build --no-cache -t ${image_name}:${tag} .

# 删除临时镜像(<none>:<none>镜像)
docker images | grep none | awk '{ print $3 }' | xargs docker rmi

# 跑起来我们的服务
docker run -itd --name ${CONTAINER} -p ${PORT}:12005 ${image_name}:${tag}