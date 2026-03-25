import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets

QuickToggleModel {
    id: root
    name: Translation.tr("Keep awake")
    icon: "coffee"

    // Bind to the authoritative Idle singleton state
    toggled: Idle.inhibit

    property bool _prevToggled: Idle.inhibit
    property bool _initialLoad: true

    // Watch for state changes from ANY source (button, restart, external trigger)
    // and fire a notification
    onToggledChanged: {
        if (_initialLoad) return

        if (toggled !== _prevToggled) {
            if (toggled) {
                Quickshell.execDetached([
                    "notify-send", "Keep Awake",
                    "☕ Screen will stay on — sleep disabled",
                    "-a", "Shell", "-i", "caffeine"
                ])
            } else {
                Quickshell.execDetached([
                    "notify-send", "Keep Awake",
                    "💤 Sleep re-enabled — screen may turn off",
                    "-a", "Shell", "-i", "caffeine-disabled"
                ])
            }
            _prevToggled = toggled
        }
    }

    // Small delay on startup so we don't fire a notification for the initial state
    Timer {
        id: initTimer
        interval: 1500
        running: true
        repeat: false
        onTriggered: {
            root._prevToggled = root.toggled
            root._initialLoad = false
        }
    }

    mainAction: () => {
        Idle.toggleInhibit()
    }

    tooltipText: toggled
        ? Translation.tr("Keep awake — click to allow sleep")
        : Translation.tr("Click to prevent sleep")
}
