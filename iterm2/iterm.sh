#!/bin/zsh
# Gestiona el perfil único de iTerm2 versionado en iterm2/profile.json.
#
#   ./iterm2/iterm.sh install   Deja profile.json como ÚNICO perfil y por defecto
#                               (ejecutar con iTerm2 cerrado, p. ej. desde Terminal.app)
#   ./iterm2/iterm.sh export    Vuelca el perfil por defecto de iTerm2 a profile.json
#                               (para guardar en el repo cambios hechos desde Settings)
set -euo pipefail

DOMAIN=com.googlecode.iterm2
PROFILE="${0:A:h}/profile.json"
TMP=$(mktemp -t iterm2-prefs).plist
trap 'rm -f "$TMP"' EXIT

defaults export "$DOMAIN" "$TMP" 2>/dev/null || plutil -create xml1 "$TMP"

case "${1:-}" in
  install)
    if [[ $(osascript -e "application id \"$DOMAIN\" is running") == true ]]; then
      echo "✗ Cierra iTerm2 primero (ejecuta esto desde Terminal.app): iTerm2 sobrescribe sus ajustes al salir." >&2
      exit 1
    fi
    GUID=$(plutil -extract Guid raw -o - "$PROFILE")
    plutil -replace "New Bookmarks" -json "[$(<"$PROFILE")]" "$TMP"
    plutil -replace "Default Bookmark Guid" -string "$GUID" "$TMP"
    defaults import "$DOMAIN" "$TMP"
    # Limpia el perfil dinámico de la configuración anterior (mismo GUID → conflicto)
    rm -f "$HOME/Library/Application Support/iTerm2/DynamicProfiles/auto-theme.json"
    echo "✓ '$(plutil -extract Name raw -o - "$PROFILE")' es ahora el único perfil de iTerm2"
    ;;
  export)
    python3 -I -c '
import json, plistlib, sys
prefs = plistlib.load(open(sys.argv[1], "rb"))
guid = prefs.get("Default Bookmark Guid")
profiles = prefs["New Bookmarks"]
profile = next((p for p in profiles if p.get("Guid") == guid), profiles[0])
with open(sys.argv[2], "w") as f:
    json.dump(profile, f, indent=2, sort_keys=True, ensure_ascii=False)
' "$TMP" "$PROFILE"
    echo "✓ Perfil exportado a $PROFILE — revisa 'git diff' y haz commit"
    ;;
  *)
    sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
    exit 1
    ;;
esac
