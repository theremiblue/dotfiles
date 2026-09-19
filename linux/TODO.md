# Remaining

- System-wide scaling - study niri and do the best practices
    - Currently, too much overrides - per-app in desktop.sh, quickshell, environment, etc
- [ ] Check Nvidia VRAM usage and apply driver profile fix: https://niri-wm.github.io/niri/Nvidia.html
    - Workaround for driver quirk where Niri leaks buffer pool memory (~1 GiB instead of ~100 MiB). Configured via `GLVidHeapReuseRatio=0` profile in `/etc/nvidia/nvidia-application-profiles-rc.d/`.
- [ ] I'm missing deep understanding of systemd
- [ ] Missing understanding of portals
- [ ] Setup screencasting with niri
    - Do not forget to block out some windows, good feature

- [ ] clipboard tool

- Software
    - Programming
        - Local llms with llama.cpp?
    - Games
        - Steam
    - Office suite (libreoffice?)
    - Music
        - [ ] other music stuff
        - REAPER
            - [ ] popups are weird
            - [ ] Rendering is not consistent
            - [ ] Audio system is weird?
    - Mail, Calendar, contacts? Fastmail?

- /home snapshots

# App issues
- browser open link not focused
- 1password opens login for some reason on start
- 1password couldn't save the token
- theme is not propagated to browser and other apps
- Screenshot is not pasted to browser

- NuPhy IO only works on chromium :(

# Other
- Customize themes everywhere
- Pick the best fonts
- try gaming
- install software
- [ ] open terminal here doesn't work from fileman
