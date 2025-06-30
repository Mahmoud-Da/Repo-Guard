# Use the official GitHub CLI image as a base for simplicity and correctness.
# NOTE: It's based on Debian and comes with gh, git, and other tools pre-installed.
FROM ghcr.io/cli/cli:latest

WORKDIR /app

COPY protect-branches.sh /usr/local/bin/protect-branches.sh

RUN chmod +x /usr/local/bin/protect-branches.sh

ENTRYPOINT ["protect-branches.sh"]
