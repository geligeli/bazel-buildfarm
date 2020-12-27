build --spawn_strategy=remote
build --genrule_strategy=remote
 --remote_executor=grpc://<bazel-buildfarm-server>:8980
bazel build --strategy=Javac=remote  --strategy=Closure=remote --remote_executor=grpc://192.168.0.147:8980 --config=opt //tensorflow/tools/pip_package:build_pip_package
bazel build --strategy=Javac=remote  --strategy=Closure=remote --remote_executor=grpc://192.168.0.147:8980 --config=opt  //main:hello-world

bazel build --remote_executor=grpc://192.168.0.147:8980 --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package

#FROM tensorflow/serving:latest-devel-gpu
FROM tensorflow/tensorflow:devel-gpu
ADD 
bazel build --config=opt --config=v2 --config=cuda //tensorflow/tools/pip_package:build_pip_package
docker swarm init --advertise-addr 192.168.99.100


sudo apt install golang-go
go get github.com/bazelbuild/bazelisk
# export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin


git config --global user.name "Stephan Gammeter"
git config --global user.email "sgammeter@gmail.com"



bazel build --remote_timeout=3600 --spawn_strategy=remote,worker,standalone,local --jobs=60 --config=cuda --config=opt //tensorflow/tools/pip_package:build_pip_package
192.168.0.147
docker run -it -p 8980:8980 --add-host=build-server:192.168.0.147 geligeli/tf-gpu-bb bash
docker run -it -p 8980:8980 --add-host=build-server:192.168.0.14  192.168.0.14:5000/foo:latest bash

docker swarm init --advertise-addr 192.168.0.14


java -jar buildfarm-server_deploy.jar


docker run --add_host= 192.168.0.14


#  --name buildfarm-redis \
docker run -d \
  -p 6379:6379 \
  --add-host buildfarm-server:192.168.0.14 \
  redis:5.0.9

docker run \
  --add-host buildfarm-server:192.168.0.14 \
  -p 8980:8980 \
  -v $(pwd)/examples:/config \
  192.168.0.14:5000/tf-gpu-bb \
  java -jar buildfarm-server_deploy.jar /config/shard-server.config.example --port=8980 --public_name=192.168.0.14:8980 --jvm_flag=-Djava.util.logging.config.file=/config/examples/prod.logging.properties

docker run \
  --add-host buildfarm-server:192.168.0.14 \
  --add-host buildfarm-redis:192.168.0.14 \
  -p 8981:8981 \
  -v $(pwd)/examples:/config \
  -v /tmp/worker:/tmp/worker \
  192.168.0.14:5000/tf-gpu-bb \
  java -jar :buildfarm-shard-worker_deploy.jar /config/shard-worker.config.example --public_name=192.168.0.15:8981 --jvm_flag=-Djava.util.logging.config.file=/config/examples/prod.logging.properties

  docker run -d --name buildfarm-worker --privileged -v $(pwd)/examples:/var/lib/buildfarm-shard-worker \
  -v /tmp/worker:/tmp/worker -p 8981:8981 --network host \
  80dw/buildfarm-worker:latest /var/lib/buildfarm-shard-worker/shard-worker.config.example --public_name=localhost:8981


  docker run -d --name buildfarm-worker --privileged -v $(pwd)/examples:/var/lib/buildfarm-shard-worker \
  -v /tmp/worker:/tmp/worker -p 8981:8981 --network host \
  80dw/buildfarm-worker:latest /var/lib/buildfarm-shard-worker/shard-worker.config.example --public_name=localhost:8981




# Start Buildfarm Cluster
start_buildfarm () {
  # Run Redis Container

  # Run Buildfarm Server Container
  docker run -d --name buildfarm-server -v $(pwd)/examples:/var/lib/buildfarm-server -p 8980:8980 --network host \
  80dw/buildfarm-server:latest /var/lib/buildfarm-server/shard-server.config.example -p 8980

  # Run Buildfarm Shard Worker Container
  mkdir -p /tmp/worker
  docker run -d --name buildfarm-worker --privileged -v $(pwd)/examples:/var/lib/buildfarm-shard-worker \
  -v /tmp/worker:/tmp/worker -p 8981:8981 --network host \
  80dw/buildfarm-worker:latest /var/lib/buildfarm-shard-worker/shard-worker.config.example --public_name=localhost:8981

  echo "Buildfarm cluster started with endpoint: localhost:8980"
}

stop_buildfarm () {
  docker stop buildfarm-server && docker rm buildfarm-server
  docker stop buildfarm-worker && docker rm buildfarm-worker
  docker stop buildfarm-redis && docker rm buildfarm-redis
}



bazel build --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --linkopt=-lrt --host_linkopt=-lrt --linkopt=-lm --host_linkopt=-lm //tensorflow/tools/pip_package:build_pip_package

build:rbe_linux 



bazel build --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --linkopt=-lrt --host_linkopt=-lrt --linkopt=-lm --host_linkopt=-lm --strategy_regexp=//tensorflow/core/kernels/mlir_generate=local //tensorflow/tools/pip_package:build_pip_package

bazel build --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --linkopt=-lrt --host_linkopt=-lrt --linkopt=-lm --host_linkopt=-lm --strategy_regexp=tensorflow/core/kernels/mlir_generated.*=local //tensorflow/tools/pip_package:build_pip_package

bazel build --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --linkopt=-lrt --host_linkopt=-lrt --linkopt=-lm --host_linkopt=-lm --strategy_regexp=tensorflow/core/kernels/mlir_generated.*=local //tensorflow/tools/pip_package:build_pip_package

bazel build --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --strategy_regexp=tensorflow/core/kernels/mlir_generated.*=local //tensorflow/tools/pip_package:build_pip_package

bazel build  --remote_executor=grpc://192.168.0.14:8980 --config=opt --config=cuda --strategy_regexp=tensorflow/core/kernels/mlir_generated.*=local --config=monolithic tensorflow/tools/benchmark:benchmark_model

24523



 netsh interface portproxy add v4tov4 listenport=8981 listenaddress=0.0.0.0 connectport=8981 connectaddress=172.25.64.1



 https://superuser.com/questions/1153496/setting-routing-between-two-networks-2-interfaces-windows-7


docker network create -d overlay foonet
docker service create \
  --name bar \
  --replicas=3 \
  --network foonet \
  alpine ping www.google.com

docker service rm bar
docker network rm foonet

  docker service create \
  --name foo \
  --replicas=3 \
  --network mynet \
  alpine ping www.google.com



https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All



https://www.reddit.com/r/bashonubuntuonwindows/comments/hdmspt/using_bridged_networking_to_get_outside_access_to/


nano /etc/wsl.conf --> disable resolv

intstall .net 5.0 runtime (for genie, from https://docs.microsoft.com/de-de/dotnet/core/install/linux-ubuntu):

wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-5.0

install genie:

curl -s https://packagecloud.io/install/repositories/arkane-systems/wsl-translinux/script.deb.sh | sudo bash




sudo nano /etc/NetworkManager/NetworkManager.conf

[ifupdown]
managed=true



sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf



geli@geli-3950-wsl:~$ cat /etc/resolv.conf
nameserver 8.8.8.8