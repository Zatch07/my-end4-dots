import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    implicitWidth: gridLayout.implicitWidth
    implicitHeight: gridLayout.implicitHeight
    property bool vertical: false
    property bool invertSide: false
    property bool trayOverflowOpen: false
    property bool showSeparator: true
    property bool showOverflowMenu: true
    property var activeMenu: null

    property list<var> pinnedItems: TrayService.pinnedItems
    property list<var> unpinnedItems: TrayService.unpinnedItems
    onUnpinnedItemsChanged: {
        if (unpinnedItems.length == 0) root.closeOverflowMenu();
    }

    function grabFocus() {
        focusGrab.active = true;
    }

    function setExtraWindowAndGrabFocus(window) {
        root.activeMenu = window;
        root.grabFocus();
    }

    function releaseFocus() {
        focusGrab.active = false;
    }

    function closeOverflowMenu() {
        root.trayOverflowOpen = false;
    }

    onTrayOverflowOpenChanged: {
        if (root.trayOverflowOpen) {
            root.grabFocus();
            autoCloseTimer.restart();
        } else {
            autoCloseTimer.stop();
        }
    }

    Timer {
        id: autoCloseTimer
        interval: 10000 
        repeat: false
        onTriggered: root.trayOverflowOpen = false
    }

    HyprlandFocusGrab {
        id: focusGrab
        active: false
        windows: [root.activeMenu]
        onCleared: {
            root.trayOverflowOpen = false;
            if (root.activeMenu) {
                root.activeMenu.close();
                root.activeMenu = null;
            }
        }
    }

    GridLayout {
        id: gridLayout
        columns: root.vertical ? 1 : -1
        anchors.fill: parent
        rowSpacing: 8
        columnSpacing: 15

        RowLayout {
            spacing: root.trayOverflowOpen ? 15 : 0
            Behavior on spacing { NumberAnimation { duration: 300; easing.type: Easing.Linear } }
            
            Layout.fillHeight: !root.vertical
            Layout.fillWidth: root.vertical
            Layout.alignment: Qt.AlignVCenter

            Item {
                id: overflowWrapper
                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
                Layout.preferredWidth: root.vertical ? -1 : (root.trayOverflowOpen ? overflowLayout.implicitWidth : 0)
                Layout.preferredHeight: root.vertical ? (root.trayOverflowOpen ? overflowLayout.implicitHeight : 0) : -1
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                clip: true
                visible: root.showOverflowMenu && root.unpinnedItems.length > 0

                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: 300; easing.type: Easing.Linear }
                }
                Behavior on Layout.preferredHeight {
                    NumberAnimation { duration: 300; easing.type: Easing.Linear }
                }

                GridLayout {
                    id: overflowLayout
                    columns: root.vertical ? 1 : -1
                    rowSpacing: 8
                    columnSpacing: 8
                    anchors.right: root.vertical ? undefined : parent.right
                    anchors.bottom: root.vertical ? parent.bottom : undefined
                    anchors.verticalCenter: root.vertical ? undefined : parent.verticalCenter
                    anchors.horizontalCenter: root.vertical ? parent.horizontalCenter : undefined

                    Repeater {
                        model: root.unpinnedItems
                        delegate: SysTrayItem {
                            required property SystemTrayItem modelData
                            item: modelData
                            Layout.fillHeight: !root.vertical
                            Layout.fillWidth: root.vertical
                            onMenuClosed: root.releaseFocus();
                            onMenuOpened: (qsWindow) => root.setExtraWindowAndGrabFocus(qsWindow);
                        }
                    }
                }
            }

            RippleButton {
                id: trayOverflowButton
                
                property real iconSize: Appearance.font.pixelSize.larger * 1.5
                property real highlightPadding: 4

                visible: root.showOverflowMenu && root.unpinnedItems.length > 0
                toggled: root.trayOverflowOpen
                property bool containsMouse: hovered

                buttonRadius: Appearance.rounding.full
                downAction: () => root.trayOverflowOpen = !root.trayOverflowOpen

                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
                
                background.implicitWidth: trayOverflowButton.iconSize + trayOverflowButton.highlightPadding
                background.implicitHeight: trayOverflowButton.iconSize + trayOverflowButton.highlightPadding
                background.anchors.centerIn: this
                colBackgroundToggled: Appearance.colors.colSecondaryContainer
                colBackgroundToggledHover: Appearance.colors.colSecondaryContainerHover
                colRippleToggled: Appearance.colors.colSecondaryContainerActive

            contentItem: CustomIcon { 
                anchors.centerIn: parent
                // HERE is where you change the icon size. 
                // You can change '1.5' to make it bigger/smaller, or replace it with a fixed number like '32'
                width: Appearance.font.pixelSize.larger * 4
                height: Appearance.font.pixelSize.larger * 4
                source: "fluent/chevron-left.svg"
                colorize: true
                color: root.trayOverflowOpen ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnLayer2
                rotation: (root.trayOverflowOpen ? 180 : 0) - (90 * root.vertical) + (180 * root.invertSide)
                Behavior on rotation {
                    NumberAnimation { duration: 300; easing.type: Easing.Linear }
                }
            }
        }
        }

        Repeater {
            model: ScriptModel {
                values: root.pinnedItems
            }

            delegate: SysTrayItem {
                required property SystemTrayItem modelData
                item: modelData
                Layout.fillHeight: !root.vertical
                Layout.fillWidth: root.vertical
                onMenuClosed: root.releaseFocus();
                onMenuOpened: (qsWindow) => {
                    root.setExtraWindowAndGrabFocus(qsWindow);
                }
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            font.pixelSize: Appearance.font.pixelSize.larger
            color: Appearance.colors.colSubtext
            text: "•"
            visible: root.showSeparator && SystemTray.items.values.length > 0
        }
    }
}
