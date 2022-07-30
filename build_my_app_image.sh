docker build . -t $1
docker image prune --filter label=stage=my_app_alpine -f
docker image prune --filter label=stage=my_app_node -f
