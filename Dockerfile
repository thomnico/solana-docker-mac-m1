
# FROM --platform=linux/arm64 debian:buster
# FROM ubuntu:20.04 as amd64
# FROM arm64v8/ubuntu:20.04

FROM --platform=linux/arm64 ubuntu:20.04
ENV solanaversion="1.8.12"
# RPC JSON
EXPOSE 8899/tcp
# RPC pubsub
EXPOSE 8900/tcp
# entrypoint
EXPOSE 8001/tcp
# (future) bank service
EXPOSE 8901/tcp
# bank service
EXPOSE 8902/tcp
# faucet
EXPOSE 9900/tcp
# tvu
EXPOSE 8000/udp
# gossip
EXPOSE 8001/udp
# tvu_forwards
EXPOSE 8002/udp
# tpu
EXPOSE 8003/udp

# tpu_forwards
EXPOSE 8004/udp
# retransmit
EXPOSE 8005/udp
# repair
EXPOSE 8006/udp
# serve_repair
EXPOSE 8007/udp
# broadcast
EXPOSE 8008/udp

# these run at `build` time
# Fix timezone issue
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt-get install -y bzip2 \
    libssl-dev libudev-dev clang \
    vim wget curl gcc pkg-config make

RUN wget -O /opt/solana-${solanaversion}.tar.gz https://github.com/solana-labs/solana/archive/refs/tags/v${solanaversion}.tar.gz
# COPY solana-${solanaversion}.tar.gz /opt/solana-${solanaversion}.tar.gz

# rustup: installs cargo, clippy rust-docs, rust-std, rustc, rustfmt
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# RUN source $HOME/.cargo/env && echo $PATH
RUN . ~/.cargo/env && echo $PATH
# RUN export PATH=~/.cargo/bin:$PATH 
ENV PATH=~/.cargo/bin:$PATH

RUN cd /opt; tar -xvf solana-${solanaversion}.tar.gz
RUN cd /opt/solana-${solanaversion}; ./scripts/cargo-install-all.sh .

ENV PATH=/opt/solana-${solanaversion}/bin:$PATH

# # Create a .profile
# RUN echo 'PATH=$PATH:$PATH:~/.cargo/bin:/opt/solana-${solanaversion}/bin' >> ~/.profile
# # Create a .bash_profile
# RUN echo 'PATH=$PATH:/$PATH:~/.cargo/bin:/opt/solana-${solanaversion}/bin' >> ~/.bash_profile

# Update bashrc
RUN echo 'PATH=$PATH:/$PATH:/opt/solana-${solanaversion}/bin' >> ~/.bashrc

# COPY solana-run.sh /usr/bin/solana-run.sh
# ENTRYPOINT [ "/usr/bin/solana-run.sh" ]

# there can be only one CMD instruction
CMD ["/bin/bash" ]
# CMD ["tail", "-f", ""]
