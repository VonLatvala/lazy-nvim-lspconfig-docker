FROM debian:trixie-20240926

ARG USERNAME="alatvala"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ca-certificates wget curl git zsh xsel locales python3-full \
    && apt-get clean

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && echo "LANG=en_US.UTF-8" > /etc/default/locale \
    && echo "export LANG=en_US.UTF-8" >> /etc/skel/.zshrc

RUN useradd \
    -b /home \
    -c nonroot \
    -d /home/${USERNAME} \
    -m \
    -s /bin/zsh \
    ${USERNAME}

RUN mkdir -p /opt/nvim/0.10.1 && \
    wget https://github.com/neovim/neovim/releases/download/v0.10.1/nvim-linux64.tar.gz \
        -O /tmp/nvim.tar.gz \
    && tar -xf /tmp/nvim.tar.gz --strip-components 1 -C /opt/nvim/0.10.1 \
    && rm /tmp/nvim.tar.gz \
    && ln -s /opt/nvim/0.10.1 /opt/nvim/current \
    && ln -s /opt/nvim/current/bin/nvim /usr/local/bin/ \
    && ln -sf /usr/local/bin/nvim /usr/local/bin/vi \
    && ln -sf /usr/local/bin/nvim /usr/local/bin/vim

USER ${USERNAME}

RUN mkdir -p \
	"/home/${USERNAME}/.local/share/nvim/lazy" \
	"/home/${USERNAME}/.config/nvim/lua/plugins" \
    && git clone \
        --depth 1 \
        --branch v11.14.1 \
        https://github.com/folke/lazy.nvim.git \
        ~/.local/share/nvim/lazy/ \
    && echo "lua require('init')" >> ~/.config/nvim/init.vim \
    && echo "require('config.lazy')" >> ~/.config/nvim/lua/init.lua

COPY lazy.lua /home/${USERNAME}/.config/nvim/lua/config/lazy.lua
COPY nvim-lspconfig.lua /home/${USERNAME}/.config/nvim/lua/plugins/nvim-lspconfig.lua
COPY lspconfig.lua /home/${USERNAME}/.config/nvim/lua/config/lspconfig.lua

WORKDIR /home/${USERNAME}

CMD [ "/usr/bin/zsh" ]
