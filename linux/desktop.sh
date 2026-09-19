#!/bin/bash

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
lnk "linux/fontconfig" "$HOME/.config/fontconfig"
"$DOTFILES_DIR/scripts/linux/install-fonts"

lnk "resources/wallpaper.jpg" "$HOME/.config/wallpapers/main.jpg"

set_mime_associations
verify_mime_associations

refresh_lantern_index
