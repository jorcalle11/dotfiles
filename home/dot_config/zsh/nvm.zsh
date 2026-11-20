export NVM_DIR="$HOME/.nvm"
# nvm lives in $NVM_DIR when installed by its script, or in Homebrew's prefix
# when installed via the Brewfile.
for d in "$NVM_DIR" /opt/homebrew/opt/nvm /usr/local/opt/nvm /home/linuxbrew/.linuxbrew/opt/nvm; do
  if [ -s "$d/nvm.sh" ]; then
    \. "$d/nvm.sh"
    [ -s "$d/bash_completion" ] && \. "$d/bash_completion"
    break
  fi
done
