FROM ubuntu:24.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Podstawowe narzędzia
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates curl git gnupg tmux jq ripgrep unzip sudo openssh-client \
      build-essential python3 python3-pip xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Node.js 22 (Claude Code wymaga 22+, przyda się też do apek i Playwrighta)
ARG NODE_MAJOR=22
RUN arch=$(dpkg --print-architecture | sed 's/amd64/x64/') \
    && v=$(curl -fsSL https://nodejs.org/dist/index.json \
         | jq -r "[.[] | select(.version | startswith(\"v${NODE_MAJOR}.\"))][0].version") \
    && curl -fsSL "https://nodejs.org/dist/$v/node-$v-linux-$arch.tar.xz" \
         | tar -xJ -C /usr/local --strip-components=1 \
    && node --version

# GitHub CLI (oficjalne repo apt)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh && rm -rf /var/lib/apt/lists/*

# Zależności systemowe przeglądarek dla testów e2e (Playwright)
RUN npx -y playwright install-deps chromium

# Użytkownik bez roota (Claude Code odrzuca tryb bez pytań jako root)
RUN useradd -m -s /bin/bash dev
USER dev
WORKDIR /home/dev

# Claude Code - natywny instalator
RUN curl -fsSL https://claude.ai/install.sh | bash \
    && /home/dev/.local/bin/claude --version
ENV PATH="/home/dev/.local/bin:${PATH}" \
    CLAUDE_CONFIG_DIR=/home/dev/.claude

COPY --chown=dev:dev start.sh /home/dev/start.sh
RUN chmod +x /home/dev/start.sh

WORKDIR /workspace
CMD ["/home/dev/start.sh"]
