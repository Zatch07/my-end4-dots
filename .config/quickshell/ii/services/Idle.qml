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
                Quickshell.execDetached(["bash", "-c", "killall -STOP hypridle"]);
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
            // Kill hypridle entirely so it forgets its passed timers
            Quickshell.execDetached(["bash", "-c", "pkill hypridle"]);
        } else {
            // Respawn a fresh hypridle daemon so it starts counting from zero!
            Quickshell.execDetached(["bash", "-c", "pkill hypridle; hypridle & pkill -RTMIN+8 waybar"]);
        }
        
        Persistent.states.idle.inhibit = root.inhibit;
    }
}
