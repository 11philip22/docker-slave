FROM openjdk:8-jdk

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN apt-get update && apt-get install -y --no-install-recommends \
	openssh-server \
	&& mkdir /var/run/sshd
RUN rm -rf /var/lib/apt/lists/*

# RUN ssh-keygen -A

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
RUN echo 'jenkins:jenkins' | chpasswd

USER ${user}
ARG AGENT_WORKDIR=/home/${user}/agent
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

USER root

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR ${AGENT_WORKDIR}

CMD ["/usr/sbin/sshd", "-D"]
