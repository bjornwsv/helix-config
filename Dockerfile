FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl unzip file git && rm -rf /var/lib/apt/lists/*

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && apt-get install -y nodejs && npm install -g typescript-language-server

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o /usr/local/bin/rust-analyzer  && \
    chmod +x /usr/local/bin/rust-analyzer && \
    . $HOME/.cargo/env &&  \
    rustup component add rust-analyzer
RUN apt-get update && apt-get install -y lldb && apt-get install llvm -y && apt install libc++-dev -y && rm -rf /var/lib/apt/lists/*

# Install Python
RUN apt-get update && apt-get install -y python3 python3-pip && npm install --global pyright &&  \
    pip install --prefix /usr black && rm -rf /var/lib/apt/lists/*

# Install Go
RUN curl -OL https://golang.org/dl/go1.22.4.linux-amd64.tar.gz && tar -xvf go1.22.4.linux-amd64.tar.gz -C /usr/local
ENV PATH="/usr/local/go/bin:${PATH}"
ENV CGO_ENABLED=1
ENV GOOS=linux
ENV GOARCH=amd64
RUN GOBIN=/usr/local/bin go install golang.org/x/tools/gopls@latest
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v1.59.1
RUN GOBIN=/usr/local/bin go install github.com/nametake/golangci-lint-langserver@latest

# Install Helix editor
RUN apt-get update && apt-get install -y software-properties-common &&  \
    add-apt-repository ppa:maveonair/helix-editor &&  \
    apt install helix &&  \
    rm -rf /var/lib/apt/lists/*

# Set the environment variable for Helix to recognize the LSP server
ENV HELIX_RUNTIME=/root/.config/helix/runtime
ENV PATH="/root/.local/bin:${PATH}"

# Setup Helix config directory
RUN mkdir -p /root/.config/helix/runtime

# Add a couple of custom themes
RUN git clone https://github.com/CptPotato/helix-themes.git
WORKDIR helix-themes
RUN sh build.sh
RUN mkdir -p /root/.config/helix/themes
RUN cp build/* /root/.config/helix/themes
WORKDIR ..
RUN rm -rf helix-themes

COPY config.toml /root/.config/helix/config.toml
COPY languages.toml /root/.config/helix/languages.toml

RUN mkdir /workspace
WORKDIR /workspace

CMD ["/bin/bash"]
