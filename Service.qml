import QtQuick
import Quickshell
import Quickshell.Io

Item {
  id: root

  property string home: Quickshell.env("HOME")
  property string pluginDir: home + "/.config/omarchy/plugins/flatpak-sync"
  property string syncScript: pluginDir + "/flatpak-sync-desktops"

  // Watch flatpak app directories for changes
  Process {
    id: watcher
    command: [
      "inotifywait",
      "-m", "-r", "-q",
      "-e", "close_write,create,delete,move",
      "--format", "%w%f",
      "/var/lib/flatpak/app",
      home + "/.local/share/flatpak/app"
    ]
    running: true

    stdout: SplitParser {
      onRead: data => {
        if (data.length > 0) {
          syncTimer.restart()
        }
      }
    }
  }

  // Debounce: wait 2 seconds after last change before syncing
  Timer {
    id: syncTimer
    interval: 2000
    onTriggered: {
      syncRunner.running = true
    }
  }

  // Run the sync script
  Process {
    id: syncRunner
    command: ["bash", root.syncScript]
    running: false

    stdout: SplitParser {
      onRead: data => console.log("[flatpak-sync] " + data)
    }
    stderr: SplitParser {
      onRead: data => console.log("[flatpak-sync] " + data)
    }
  }
}
