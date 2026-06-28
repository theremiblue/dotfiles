# Fontconfig

This dotfiles fontconfig setup maps generic font families to the fonts vendored in `fonts/`.

- `monospace`: 0xProto NL Regular, then Noto Sans Mono, IBM Plex Mono, JetBrains Mono, Terminus
- `sans-serif` / `sans`: Inter, then Noto Sans, IBM Plex Sans
- `serif`: Merriweather, then Noto Serif, IBM Plex Serif

The monospace alias uses the no-ligature 0xProto build and also requests common ligature features off through fontconfig.

To switch fonts later, edit `fonts.conf` and move the preferred family to the top of the matching `<prefer>` list. After changing it, run:

```sh
fc-cache -r
fc-match monospace
fc-match sans-serif
fc-match serif
```

Restart already-running apps after the cache refresh.
