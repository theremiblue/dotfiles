# dotfiles

### Setup

I assume `bash` and `git` are installed on the system.

```bash
git clone https://github.com/theremiblue/dotfiles.git ~/dotfiles
cd ~/dotfiles

./packages.sh
./setup.sh
```

Additionally, you can install linux desktop config with `./setup.sh --desktop`.
Reference the [linux](./linux/README.md) folder for details.

Setup logs:
- `+ name` - added or changed `name`
- `@ name` - ensured `name` was already present

Scripts are designed to be easy-to-maintain.
Just read them.
If it's hard to read - time for edit.

### Local shell config

Put your machine shell configuration under `~/.posix-profile`.
Don't edit `.zshrc`, `.bashrc`, etc.

### Additional notes

- Symlinks on Windows Git Bash require Developer Mode
  enabled (Settings > Developer settings). Do that before clonning repo.
