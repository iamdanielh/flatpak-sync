# flatpak-sync (Omarchy shell plugin)

An Omarchy shell plugin that auto-syncs Flatpak desktop files, icons, and
Omarchy menu entries whenever a Flatpak app is installed or removed.

It watches `/var/lib/flatpak/app` (and user flatpaks) with `inotifywait`,
then:
- copies `.desktop` files and icons into the user application/icon dirs,
- fixes broken symlinks and refreshes desktop/icon caches,
- auto-adds a `media.<app_id>` entry to `~/.config/omarchy/extensions/omarchy-menu.jsonc`
  for each new Flatpak app so it shows up in the Omarchy launcher/menu.

## Requirements

- `inotify-tools` (provides `inotifywait`)
- `flatpak`
- Omarchy shell (`omarchy-shell`)

## Install

Clone it as a user shell plugin (switches the shell to the cloned copy):

```bash
omarchy plugin clone flatpak-sync --source https://github.com/<you>/flatpak-sync
```

Or copy it manually:

```bash
mkdir -p ~/.config/omarchy/plugins
cp -r flatpak-sync ~/.config/omarchy/plugins/
omarchy-shell shell rescanPlugins
```

The shell hot-reloads files under `~/.config/omarchy/plugins/` on save, so a
manual copy takes effect immediately.

`.config/omarchy/plugins/flatpak-sync/flatpak-sync-desktops` is the sync
script; the `manifest.json` registers it as a long-running `service` plugin.

## Layout

```
flatpak-sync/
├── manifest.json              # plugin metadata (id: flatpak-sync, kind: service)
├── Service.qml                # inotify watcher + debounce + runner
└── flatpak-sync-desktops      # the sync script (portable, uses $HOME)
```

## License

MIT
