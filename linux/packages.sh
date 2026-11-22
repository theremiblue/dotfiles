#!/bin/bash
set -euo pipefail

pacman_packages=(
    # Compositor and session
    niri
    polkit-kde-agent
    swaybg
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xwayland-satellite

    # Shell and UI
    quickshell

    # Terminal
    ghostty

    # Browser
    librewolf

    # File manager
    gvfs # TODO: figure out what it is
    thunar
    thunar-archive-plugin
    thunar-volman

    # Media and viewers
    calibre
    loupe
    obs-studio
    qpwgraph
    strawberry
    vlc

    # Communication and production
    discord
    reaper
    telegram-desktop

    # Audio and media control
    brightnessctl
    pipewire
    pipewire-alsa
    pipewire-audio
    pipewire-jack
    pipewire-pulse
    playerctl
    wireplumber

    # Notifications and clipboard
    libnotify
    wl-clipboard

    # System and hardware utilities
    blueman
    bluez
    bluez-utils
    desktop-file-utils
    keyd
    networkmanager
    xdg-utils

    # Fonts
    fontconfig
    noto-fonts-cjk
    noto-fonts-emoji
)

aur_packages=(
    # Password manager
    1password
    1password-cli

    # VPN
    nordvpn-bin
)

ensure_paru() {
    if command -v paru >/dev/null 2>&1; then
        return 0
    fi

    sudo pacman -S --needed --noconfirm base-devel git
    local build_dir
    build_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/paru-bin.git "$build_dir" || git clone https://aur.archlinux.org/paru.git "$build_dir"
    (cd "$build_dir" && makepkg -si --noconfirm)
    rm -rf "$build_dir"
}

if [ "${1:-}" = "--dry" ]; then
    printf '%s\n' "${pacman_packages[@]}" "${aur_packages[@]}"
    exit 0
fi

if ! command -v pacman >/dev/null 2>&1; then
    echo "pacman not found: arch linux required" >&2
    exit 1
fi

sudo pacman -S --needed --noconfirm "${pacman_packages[@]}"
ensure_paru
paru -S --needed --noconfirm "${aur_packages[@]}"
