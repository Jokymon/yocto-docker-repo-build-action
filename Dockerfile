FROM ubuntu:16.04

RUN apt-get update

RUN apt-get install -q -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
	build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
	xz-utils debianutils iputils-ping libsdl1.2-dev xterm

RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN wget https://storage.googleapis.com/git-repo-downloads/repo-1 -O /bin/repo
RUN chmod a+x /bin/repo

RUN git config --global color.ui false
RUN git config --global user.email "builder@example.com"
RUN git config --global user.name "Builder User"

VOLUME /yocto_root
VOLUME /github/workspace

ADD entrypoint.sh /
ADD disable_root_user_check.patch /

ENTRYPOINT ["/entrypoint.sh"]
