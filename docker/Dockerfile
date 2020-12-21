FROM tensorflow/tensorflow:devel-gpu
WORKDIR /usr/local/bin
RUN wget https://github.com/bazelbuild/bazelisk/releases/download/v1.7.4/bazelisk-linux-amd64 -O bazelisk
RUN chmod a+x bazelisk
WORKDIR /root
RUN git clone https://github.com/bazelbuild/bazel-buildfarm.git
WORKDIR /root/bazel-buildfarm
# RUN git checkout tags/1.4.0
RUN bazelisk build //src/main/java/build/buildfarm:buildfarm-server_deploy.jar \
    //src/main/java/build/buildfarm:buildfarm-operationqueue-worker_deploy.jar \
    //src/main/java/build/buildfarm:buildfarm-shard-worker_deploy.jar
RUN mv bazel-bin/src/main/java/build/buildfarm/buildfarm-*deploy.jar .
RUN bazelisk clean
COPY tf_configure.bazelrc /tensorflow_src/.tf_configure.bazelrc
EXPOSE 8980
EXPOSE 8981