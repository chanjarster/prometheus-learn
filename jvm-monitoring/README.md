# Prometheus监控JVM

* 对应文章: https://chanjarster.github.io/post/prom-grafana-jvm/ 
* jmx-exporter config: [jmx-exporter-config.yml](jmx-exporter-config.yml)
* Prometheus rules: None
* Alertmanager config: None
* Grafana dashboard: [JVM dashboard](https://grafana.com/dashboards/8563)


```bash
# docker run所有容器
./demo.sh run

# docker stop所有容器
./demo.sh stop

# docker start所有容器
./demo.sh start

# docker restart所有容器
./demo.sh restart

# 清理prom-data和grafana-data
./demo.sh clear-data

# docker rm所有容器
./demo.sh clear-container
```