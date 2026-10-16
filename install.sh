#!/usr/bin/env bash
# Instaluje/aktualizuje wireguard-tray w systemie. Uruchom jako root (sudo -A ./install.sh).
# Działający tray podmienia się dopiero po ponownym zalogowaniu (albo: pkill -x wireguard-tray; /usr/local/lib/wireguard-tray/wireguard-tray &).
# Kod wyjścia 10 = brak NetworkManagera, nic nie zainstalowano.
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
LIB=/usr/local/lib/wireguard-tray
[[ $EUID -eq 0 ]] || { echo "Uruchom przez sudo"; exit 1; }

if ! command -v nmcli >/dev/null; then
    echo "wireguard-tray: brak NetworkManagera (nmcli) - pomijam"
    exit 10
fi

# wireguard-tools nie jest potrzebne (NetworkManager ma WireGuard wbudowany), iproute2 jest zawsze.
pacman -S --needed --asdeps --noconfirm kdialog wl-clipboard libnotify

BIN=$("$SRC/build.sh" "$SRC")

install -Dm755 "$BIN" "$LIB/wireguard-tray"
rm -rf "$LIB/icons"
install -Dm644 -t "$LIB/icons" "$SRC"/icons/*.svg
install -Dm644 -t /etc/xdg/autostart "$SRC/wireguard-tray.desktop"
install -Dm644 "$SRC/wireguard-tray-launcher.desktop" /usr/local/share/applications/wireguard-tray.desktop
install -Dm644 "$SRC/wireguard-tray.svg" /usr/local/share/icons/hicolor/scalable/apps/wireguard-tray.svg
gtk-update-icon-cache -qtf /usr/local/share/icons/hicolor 2>/dev/null || true
# Bez reguły polkit: up/down to network-control (aktywna sesja - bez hasła), a import/zmiany
# (settings.modify.system) dla grupy wheel przepuszcza reguła z pakietu NetworkManager.
