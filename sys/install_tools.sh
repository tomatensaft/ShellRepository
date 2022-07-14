
#!/bin/sh
#PDX-License-Identifier: MIT

# install some useful tools
env ASSUME_ALWAYS_YES=YES pkg install \
	bash \
	cmake \
	fish \
	fusefs-sshfs \ # ntfs
	gcc \
	gdb \
	git \
	htop \
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