#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$DOTFILES_DIR/scripts/setup-lib.sh"

# TODO: do we want to setup packages here or not?
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

make_desktop_noscale_override() {
    local desktop_id="$1"
    local app_cmd="$2"
    local app_env="${3:-QT_SCALE_FACTOR=1 GDK_SCALE=1}"
    local src=""
    local dst="$HOME/.local/share/applications/$desktop_id"

    echo "Creating no-scale desktop override: $desktop_id -> env $app_env $app_cmd"

    mkdir -p "$HOME/.local/share/applications"

    if [[ -f "/usr/share/applications/$desktop_id" ]]; then
        src="/usr/share/applications/$desktop_id"
    elif [[ -f "$HOME/.local/share/applications/$desktop_id" ]]; then
        src="$HOME/.local/share/applications/$desktop_id"
    else
        echo "Missing desktop file: $desktop_id" >&2
        return 1
    fi

    cp "$src" "$dst"

    # Replace only non-action Exec lines. Leave Desktop Actions alone for now.
    sed -i \
    -e "/^\[Desktop Entry\]/,/^\[/ s|^Exec=.*|Exec=env $app_env $app_cmd %U|" \
    "$dst"

    echo "Installed no-scale override at $dst"

    update-desktop-database "$HOME/.local/share/applications" >/dev/null 2>&1 || true
}

refresh_lantern_index() {
    echo "Refreshing Lantern application index..."

    if quickshell ipc call lantern refresh >/dev/null 2>&1; then
        echo "Lantern application index refreshed."
    else
        echo "Lantern application index refresh skipped; Quickshell IPC is unavailable." >&2
    fi
}

lnk "linux/niri" "$HOME/.config/niri"
lnk "linux/quickshell" "$HOME/.config/quickshell"
lnk "linux/uwsm" "$HOME/.config/uwsm"
lnk "linux/fontconfig" "$HOME/.config/fontconfig"

lnk "resources/wallpaper.jpg" "$HOME/.config/wallpapers/main.jpg"

set_mime_associations
verify_mime_associations

make_desktop_noscale_override \
  org.strawberrymusicplayer.strawberry.desktop \
  strawberry

make_desktop_noscale_override \
  com.obsproject.Studio.desktop \
  obs

make_desktop_noscale_override \
  calibre-gui.desktop \
  "calibre --detach"

make_desktop_noscale_override \
  org.rncbc.qpwgraph.desktop \
  qpwgraph \
  "QT_QPA_PLATFORM=xcb QT_SCALE_FACTOR=1 QT_AUTO_SCREEN_SCALE_FACTOR=0 QT_ENABLE_HIGHDPI_SCALING=0 QT_SCREEN_SCALE_FACTORS=1 QT_FONT_DPI=96 GDK_SCALE=1"

refresh_lantern_index
