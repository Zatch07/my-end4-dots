pragma Singleton
import qs.modules.common
import QtQuick
import Quickshell

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    property bool inhibit: false

    Connections {
        target: Persistent
        function onReadyChanged() {
            if (!Persistent.isNewHyprlandInstance) {
                root.inhibit = Persistent.states.idle.inhibit;
            } else {
                Persistent.states.idle.inhibit = root.inhibit;
            }
            
            // Sync initial state
            if (root.inhibit) {
                Quickshell.execDetached(["bash", "-c", "systemd-inhibit --what=idle --who=\"Quickshell\" --why=\"User requested\" sleep infinity & echo $! > /tmp/qs_idle_inhibit.pid"]);
            }
        }
    }

    function toggleInhibit(active = null) {
        if (active !== null) {
            root.inhibit = active;
        } else {
            root.inhibit = !root.inhibit;
        }
        
        if (root.inhibit) {
            // Initiate a soft inhibitor to prevent idle timers without killing the service
            Quickshell.execDetached(["bash", "-c", "systemd-inhibit --what=idle --who=\"Quickshell\" --why=\"User requested\" sleep infinity & echo $! > /tmp/qs_idle_inhibit.pid"]);
        } else {
            // Kill the soft inhibitor
            Quickshell.execDetached(["bash", "-c", "kill $(cat /tmp/qs_idle_inhibit.pid 2>/dev/null) 2>/dev/null; rm -f /tmp/qs_idle_inhibit.pid"]);
        }
        
        Persistent.states.idle.inhibit = root.inhibit;
    }
}
