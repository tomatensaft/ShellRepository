
#!/bin/sh
#PDX-License-Identifier: MIT

# install some useful tools
env ASSUME_ALWAYS_YES=YES pkg install \
	TwinCAT-SDK-internal_4024 \
	bash \
	cmake \
	fish \
	fusefs-sshfs \
	gcc \
	gdb \
	git \
	htop \
	jevops-internal \
	joe \
	jq \
	llvm \
	neovim \
	openfortivpn \
	os-generic-userland-devtools \
	poudriere-trueos \
	rsync \
	samba412 \
	src \
	tmux \
	wget \
	xmlstarlet