#!/bin/bash
CMD_NAME=`basename $0`
COMMAND=$1

function run-prom
{
  docker pull prom/prometheus
  
  mkdir -p prom-data

  docker run -d \
    --name=prometheus \
    --network test-overlay \
    -p 9090:9090 \
    -v $(pwd):/prometheus-config \
    -v $(pwd)/prom-data:/prometheus \
    prom/prometheus --config.file=/prometheus-config/prom-config.yml
  
}

function run-mocks
{
  docker pull chanjarster/prometheus-mock-data:latest
  
  docker service create \
    --name mock \
    --replicas 3 \
    --network test-overlay \
    --limit-memory 96M \
    --mount type=bind,src=$(pwd)/scrape-data.txt,dst=/home/java-app/etc/scrape-data.txt \
    chanjarster/prometheus-mock-data:latest
  
  docker run -d \
    -v $(pwd)/scrape-data.txt:/home/java-app/etc/scrape-data.txt \
    --network test-overlay \
    --name standalone-mock \
    chanjarster/prometheus-mock-data:latest
}


function run
{
  echo 'Run all containers'

  run-mocks
  run-prom
 
  echo 'Open browser: http://localhost:9090 for Prometheus'
   
}

function start
{
  echo 'Scale service mock to 3'
  docker service scale mock=3

  echo 'Start standalone-mock'
  docker start standalone-mock
  
  echo 'Start prometheus'
  docker start prometheus
}

function stop
{
  echo 'Stop prometheus'
  docker stop prometheus

  echo 'Stop standalone-mock'
  docker stop standalone-mock
  
  echo 'Scale service mock to 0'
  docker service scale mock=0
}

function restart
{
  
  echo 'Restart all containers'
  
  docker stop prometheus
  docker service scale mock=0
  docker service scale mock=3
  docker restart standalone-mock
  docker start prometheus
}

function clear-data
{
  echo "Clear all containers' data"
  rm -rf $(pwd)/prom-data/*
}

function clear-container
{
  echo 'Clear all containers'
  stop
  docker service rm mock
  docker rm prometheus standalone-mock
}

function reload-config
{
  echo 'Reload Prometheus config'
  docker exec -t prometheus kill -SIGHUP 1
}

function usage
{
  echo "Usage: ${CMD_NAME} run|start|stop|restart|reload-config|clear-data|clear-container"
}


case $COMMAND in
  'run')
    run
    ;;
  'start')
    start
    ;;
  'stop')
    stop
    ;;
  'restart')
    restart
    ;;
  'reload-config')
    reload-config
    ;;
  'clear-data')
    clear-data
    ;;
  'clear-container')
    clear-container
    ;;
  *)
    usage
    exit 1
  ;;
esac

exit 0