#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$DOTFILES_DIR/scripts/setup-lib.sh"

"$DOTFILES_DIR/linux/packages.sh" "$@"
set_mime_associations() {
    echo "Setting MIME associations..."

    xdg-settings set default-web-browser librewolf.desktop

    xdg-mime default librewolf.desktop x-scheme-handler/http
    xdg-mime default librewolf.desktop x-scheme-handler/https
    xdg-mime default librewolf.desktop text/html
    xdg-mime default librewolf.desktop application/xhtml+xml

    xdg-mime default thunar.desktop inode/directory

    xdg-mime default org.gnome.Loupe.desktop image/png
    xdg-mime default org.gnome.Loupe.desktop image/jpeg
    xdg-mime default org.gnome.Loupe.desktop image/webp
    xdg-mime default org.gnome.Loupe.desktop image/gif
    xdg-mime default org.gnome.Loupe.desktop image/bmp
    xdg-mime default org.gnome.Loupe.desktop image/tiff

    xdg-mime default vlc.desktop video/mp4
    xdg-mime default vlc.desktop video/x-matroska
    xdg-mime default vlc.desktop video/webm
    xdg-mime default vlc.desktop video/x-msvideo
    xdg-mime default vlc.desktop video/quicktime
    xdg-mime default vlc.desktop video/mpeg
    xdg-mime default vlc.desktop video/x-ms-wmv

    xdg-mime default vlc.desktop audio/mpeg
    xdg-mime default vlc.desktop audio/flac
    xdg-mime default vlc.desktop audio/ogg
    xdg-mime default vlc.desktop audio/wav
    xdg-mime default vlc.desktop audio/mp4

    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/flac
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/x-flac
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/mpeg
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/ogg
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/wav
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/x-wav
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/mp4
    xdg-mime default org.strawberrymusicplayer.strawberry.desktop audio/aac


    echo "MIME associations set."
}

verify_mime_associations() {
    echo "Browser:"
    xdg-settings get default-web-browser || true

    echo
    echo "HTTP:"
    xdg-mime query default x-scheme-handler/http || true

    echo
    echo "HTTPS:"
    xdg-mime query default x-scheme-handler/https || true

    echo
    echo "HTML:"
    xdg-mime query default text/html || true

    echo
    echo "Directories:"
    xdg-mime query default inode/directory || true

    echo
    echo "Images: "
    xdg-mime query default image/png
    xdg-mime query default image/jpeg

    echo
    echo "Videos: "
    xdg-mime query default video/mp4
    xdg-mime query default video/x-matroska

    echo
    echo "Music: "
    xdg-mime query default audio/flac
}

install_keyd_config() {
    local src="$DOTFILES_DIR/linux/keyd/default.conf"
    local dst="/etc/keyd/default.conf"

    if ! command -v keyd >/dev/null 2>&1; then
        echo "keyd is not installed; skipping keyd service setup" >&2
        return 1
    fi

    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
        sudo install -Dm644 "$src" "$dst"
        echo "+ keyd/default.conf"
    else
        echo "@ keyd/default.conf"
    fi

    if systemctl is-active --quiet keyd; then
        sudo keyd reload
        return
    fi

    sudo systemctl enable --now keyd
}

install_nvidia_profile() {
    local src="$DOTFILES_DIR/linux/nvidia/50-limit-free-buffer-pool-in-wayland-compositors.json"
    local dst="/etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json"

    if ! command -v nvidia-smi >/dev/null 2>&1 && [ ! -d /etc/nvidia ]; then
        return
    fi

    if [ ! -f "$dst" ] || ! cmp -s "$src" "$dst"; then
        sudo install -Dm644 "$src" "$dst"
        echo "+ nvidia-application-profiles/50-limit-free-buffer-pool-in-wayland-compositors.json"
    else
        echo "@ nvidia-application-profiles/50-limit-free-buffer-pool-in-wayland-compositors.json"
    fi
}

set_dark_theme() {
    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    fi
}

lnk "linux/niri" "$HOME/.config/niri"
lnk "linux/quickshell" "$HOME/.config/quickshell"
lnk "linux/fontconfig" "$HOME/.config/fontconfig"
lnk "linux/gtk-3.0/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
lnk "linux/gtk-4.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
lnk "linux/xfce4/helpers.rc" "$HOME/.config/xfce4/helpers.rc"
lnk "linux/Thunar/uca.xml" "$HOME/.config/Thunar/uca.xml"
lnk "linux/librewolf/librewolf.overrides.cfg" "$HOME/.config/librewolf/librewolf/librewolf.overrides.cfg"
"$DOTFILES_DIR/scripts/linux/install-fonts"

lnk "resources/wallpaper.jpg" "$HOME/.config/wallpapers/main.jpg"

install_nvidia_profile
install_keyd_config
set_dark_theme
set_mime_associations
verify_mime_associations
