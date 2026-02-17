FROM ubuntu:24.04

RUN apt-get update \
	&& apt-get install -y \
	git \
	g++ \
	python3 \
	python3-pip \
	nodejs \
	npm \
	lldb \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

RUN	pip install online-judge-tools --break-system-packages
RUN npm install -g atcoder-cli

RUN git clone https://github.com/atcoder/ac-library.git /tmp/acl \
	&& mv /tmp/acl/atcoder /usr/local/include/ \
	&& rm -rf /tmp/acl
ENV CPLUS_INCLUDE_PATH=/usr/local/include

WORKDIR /atcoder