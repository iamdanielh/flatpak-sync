# Flatpak Sync (Omarchy shell plugin)

An Omarchy shell plugin that auto-syncs Flatpak desktop files, icons, and
Omarchy menu entries whenever a Flatpak app is installed or removed.

It watches `/var/lib/flatpak/app` (and user flatpaks) with `inotifywait`,
then:
- copies `.desktop` files and icons into the user application/icon dirs,
- fixes broken symlinks and refreshes desktop/icon caches,
- auto-adds a `media.<app_id>` entry to `~/.config/omarchy/extensions/omarchy-menu.jsonc`
  for each new Flatpak app so it shows up in the Omarchy launcher/menu.

Plugin ID: `io.github.iamdanielh.flatpak-sync`

## Requirements

- `inotify-tools` (provides `inotifywait`)
- `flatpak`
- Omarchy shell (`omarchy-shell`)

## Install

```bash
omarchy plugin add https://github.com/iamdanielh/flatpak-sync.git --enable
```

This clones the repo, validates the manifest, and enables the `service`
plugin in the shell. Be sure to read the source before enabling, as plugins
run unsandboxed inside your shell process.

Alternatively, copy it manually and rescan:

```bash
mkdir -p ~/.config/omarchy/plugins
cp -r flatpak-sync ~/.config/omarchy/plugins/io.github.iamdanielh.flatpak-sync/
omarchy-shell shell rescanPlugins
```

## Removal

```bash
omarchy plugin remove io.github.iamdanielh.flatpak-sync
```

Removal disables the plugin and deletes its git checkout. It does **not**
remove the desktop files, icons, or menu entries it generated — those are
yours and left in place. To clean those up, delete the synced Flatpak
entries under `~/.config/omarchy/extensions/omarchy-menu.jsonc` and run:

```bash
update-desktop-database ~/.local/share/applications
gtk-update-icon-cache -f ~/.local/share/icons/hicolor
```

## Layout

```
flatpak-sync/
├── manifest.json              # plugin metadata (service kind)
├── Service.qml                # inotify watcher + debounce + runner
└── flatpak-sync-desktops      # the sync script (portable, uses $HOME)
```

## License

MIT
