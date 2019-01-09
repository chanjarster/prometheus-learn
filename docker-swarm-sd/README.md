# 监控Docker swarm overlay网络中的container

* 对应文章: [Prometehus监控Docker Swarm Overlay网络中的容器](https://chanjarster.github.io/post/p8s-scrape-container-in-docker-swarm-overlay-network/)
* Prometheus rules: None
* Alertmanager config: None


```bash
# docker run所有容器
./demo.sh run

# docker stop所有容器
./demo.sh stop

# docker start所有容器
./demo.sh start

# docker restart所有容器
./demo.sh restart

# 清理prom-data
./demo.sh clear-data

# docker rm所有容器
./demo.sh clear-container
```