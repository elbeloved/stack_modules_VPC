!/bin/bash -xe

mkdir -p /etc/ecs
echo ECS_CLUSTER=${CLUSTER} >> /etc/ecs/ecs.config