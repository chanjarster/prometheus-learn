```bash
# docker run所有容器
./demo.sh run

# docker stop所有容器
./demo.sh stop

# docker start所有容器
./demo.sh start

# docker restart所有容器
./demo.sh restart

# 清理prom-data和grafana-data，再重启docker restart所有容器
./demo.sh clear-data

# 清理prom-data和grafana-data，docker rm所有容器
./demo.sh clear-all
```