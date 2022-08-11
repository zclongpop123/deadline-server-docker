Deadline Repository Docker
--
- 构建镜像
```bash
docker build -t deadline-repository:10 .
```
- 运行容器
```bash
docker run --name DeadlineRepository10 -d -v /opt/Thinkbox:/opt/Thinkbox -v /etc/localtime:/etc/localtime:ro -p 27100:27100 deadline-repository:10
```
- DockerCompose 运行
```bash
docker-compose up -d deadline-repo
```
