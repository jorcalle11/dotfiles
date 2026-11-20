# Google Cloud SDK (only if installed)
if [ -d "$HOME/google-cloud-sdk" ]; then
  [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
  [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
