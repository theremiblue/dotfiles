# Quickshell shell

This is a Quickshell replacement for the previous Waybar and notification daemon setup.

Note: this config is vibecoded and should be treated as personal, fast-moving dotfiles rather than a polished reusable package.

## Install

```sh
sudo pacman -S quickshell
```

The config expects Hyprland integration for workspace state:

```sh
hyprctl
```

It also owns `org.freedesktop.Notifications` through `Quickshell.Services.Notifications`, so do not start a second notification daemon.

## Layout

The config is split by responsibility:

- `app/` contains concrete shell implementations: bar items, drawers, notifications, and screen windows.
- `ui/primitives/` contains low-level reusable building blocks such as text, icons, icon buttons, switches, and drawers.
- `ui/controls/` contains small composed controls reused by features.
- `services/` contains singleton state and OS integration.
- `config/` contains theme and sizing constants.

Implementation files under `app/` may import `ui/`, `services/`, and `config/`. Reusable UI should not import feature implementations.

## Run manually

From this directory:

```sh
quickshell -p .
```

Or after linking/copying this directory to `~/.config/quickshell`:

```sh
quickshell
```

From the repo root, use the development helper:

```sh
./dev
```

## Hyprland autostart

Use this autostart command:

```sh
exec-once = quickshell
```

If you want to test manually:

```sh
quickshell -p ~/dotfiles/linux/quickshell
```
