#!/bin/bash
CMD_NAME=`basename $0`
COMMAND=$1

function run
{
  echo 'Run all containers'
  docker run -d \
    --name tomcat-1 \
    -v $(pwd):/jmx-exporter \
    -e CATALINA_OPTS="-Xms64m -Xms64m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar=6060:/jmx-exporter/jmx-exporter-config.yml" \
    -p 6060:6060 \
    -p 8080:8080 \
    tomcat:8.5-alpine

  docker run -d \
    --name tomcat-2 \
    -v $(pwd):/jmx-exporter \
    -e CATALINA_OPTS="-Xms64m -Xms64m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar=6060:/jmx-exporter/jmx-exporter-config.yml" \
    -p 6061:6060 \
    -p 8081:8080 \
    tomcat:8.5-alpine

  docker run -d \
    --name tomcat-3 \
    -v $(pwd):/jmx-exporter \
    -e CATALINA_OPTS="-Xms64m -Xms64m -javaagent:/jmx-exporter/jmx_prometheus_javaagent-0.3.1.jar=6060:/jmx-exporter/jmx-exporter-config.yml" \
    -p 6062:6060 \
    -p 8082:8080 \
    tomcat:8.5-alpine

  mkdir -p prom-data

  HOSTNAME=$(hostname) envsubst < prom-config.yml.tmpl > prom-config.yml

  docker run -d \
    --name=prometheus \
    -p 9090:9090 \
    -v $(pwd):/prometheus-config \
    -v $(pwd)/prom-data:/prometheus \
    prom/prometheus --config.file=/prometheus-config/prom-config.yml

  mkdir -p grafana-data

  docker run -d \
    --name=grafana \
    -v $(pwd)/grafana-data:/var/lib/grafana \
    -p 3000:3000 \
    grafana/grafana
  
  echo ''
  echo 'Open browser: http://localhost:8080 for tomcat-1'
  echo 'Open browser: http://localhost:6060 for tomcat-1 metrics'
  echo ''
  echo 'Open browser: http://localhost:8081 for tomcat-2'
  echo 'Open browser: http://localhost:6061 for tomcat-2 metrics'
  echo ''
  echo 'Open browser: http://localhost:8082 for tomcat-3'
  echo 'Open browser: http://localhost:6062 for tomcat-3 metrics'
  echo ''
  echo 'Open browser: http://localhost:9090 for prometheus'
  echo 'Open browser: http://localhost:3000 for grafana (default username/password: admin/admin)'
}

function start
{
  echo 'Start all containers'
  docker start prometheus grafana tomcat-1 tomcat-2 tomcat-3 
}

function stop
{
  echo 'Stop all containers'
  docker stop prometheus grafana tomcat-1 tomcat-2 tomcat-3 
}

function restart
{
  echo 'Restart all containers'
  docker restart prometheus grafana tomcat-1 tomcat-2 tomcat-3 
}

function clear-data
{
  echo "Clear all containers' data and restart"
  stop
  rm-data
  start
}

function rm-data 
{
  rm -rf $(pwd)/prom-data/* $(pwd)/grafana-data/*
}

function clear-all
{
  echo 'Clear all containers and data'
  stop
  rm-data
  docker rm prometheus grafana tomcat-1 tomcat-2 tomcat-3
}

function usage
{
  echo "Usage: ${CMD_NAME} run|start|stop|restart|clear-data|clear-all"
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
  'clear-data')
    clear-data
    ;;
  'clear-all')
    clear-all
    ;;
  *)
    usage
    exit 1
  ;;
esac

exit 0