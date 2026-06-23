# avh-fvp models are x86_64 Linux binaries, so pin amd64 even on arm64 hosts.
FROM --platform=linux/amd64 ubuntu:22.04

SHELL ["/bin/bash", "-c"]

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y install \
        build-essential \
        curl \
        git \
        gh \
        less \
        libatomic1 \
        libncurses5 \
        libtinfo5 \
        locales \
        nano \
        python3 \
        python3-pip \
        python-is-python3 \
        sudo \
        unzip && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash && \
    echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    mkdir -p /workspaces && chown $USER_UID:$USER_GID /workspaces

ADD vcpkg-configuration.json /home/
ADD postCreateCommand.sh /home/
RUN chmod +x /home/postCreateCommand.sh

USER $USERNAME
WORKDIR /home/$USERNAME
CMD ["/bin/bash"]
