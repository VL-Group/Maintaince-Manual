# Docker 使用方法

Docker 是一个镜像式管理的虚拟化程序，使用镜像在容器中运行。创建容器时，会从已保存的镜像中直接创建，销毁容器时，如果不提交更改，那么对容器所做的所有更改都不会保存。如果希望持久保存数据，则应该将数据挂载到容器下的一个目录中，而不是在容器中直接读写。

* 运行一个容器
```console
user@host:~$ docker run -it --gpus all [IMAGE_NAME] /bin/bash
```

* 提交容器的所有更改，并更新原来的镜像
```console
user@host:~$ docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
dd4a90d9f5c0        bvlc/caffe:gpu      "/bin/bash"         4 minutes ago       Up 4 minutes                            gallant_davinci

user@host:~$ docker commit dd4a90d9f5c0 zpp/densecap:latest
user@host:~$ docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
zpp/densecap        latest              ac4b02d57ebf        10 seconds ago      3.62GB
nvidia/cuda         10.0-base           841d44dd4b3c        7 months ago        110MB
bvlc/caffe          gpu                 ba28bcb1294c        2 years ago         3.38GB

```

* 运行一个容器，并将本地目录挂载到容器的 /mnt 目录下面
```console
user@host:~$ docker run -v /HOST_DIR:/mnt -it --gpus all zpp/densecap /bin/bash
```
这样，对 /mnt 的所有读写操作就是对 `HOST_DIR` 的直接操作。
