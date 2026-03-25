import qs
import qs.services
import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io

// Slanted wallpaper picker — adapted from ilyamiro/nixos-configuration
// Bridges into the existing end-4 Wallpapers.qml backend for full
// Matugen / mpvpaper / switchwall.sh integration.
Item {
    id: root

    readonly property string thumbDir: "file://" + FileUtils.trimFileProtocol(Directories.genericCache) + "/wallpaper_picker/thumbs"
    readonly property string srcDir: FileUtils.trimFileProtocol(Directories.pictures) + "/Wallpapers"
    property bool useDarkMode: Appearance.m3colors.darkmode

    // Slant geometry — matches the original dotfile exactly
    readonly property int itemWidth: 300
    readonly property int itemHeight: 420
    readonly property int borderWidth: 3
    readonly property real skewFactor: -0.35

    // Jump to the thumbnail that matches the currently active wallpaper
    property bool _focusDone: false
    function focusCurrentWallpaper() {
        if (_focusDone) return
        const currentWall = Config.options.background.wallpaperPath
        if (!currentWall || currentWall.length === 0) return
        if (thumbModel.status !== FolderListModel.Ready) return

        const currentName = currentWall.split("/").pop()
        const targetThumb = currentName + ".jpg"
        for (let i = 0; i < thumbModel.count; i++) {
            if (thumbModel.get(i, "fileName") === targetThumb) {
                view.currentIndex = i
                view.positionViewAtIndex(i, ListView.Center)
                _focusDone = true
                return
            }
        }
    }

    // ── Keyboard navigation ─────────────────────────────────────────────────
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Escape) {
            GlobalStates.wallpaperSelectorOpen = false
            event.accepted = true
        } else if (event.key === Qt.Key_Left) {
            view.decrementCurrentIndex()
            event.accepted = true
        } else if (event.key === Qt.Key_Right) {
            view.incrementCurrentIndex()
            event.accepted = true
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            if (view.currentItem) view.currentItem.pickWallpaper()
            event.accepted = true
        }
    }

    // ── Thumbnail folder model ──────────────────────────────────────────────
    // Reads from ~/.cache/wallpaper_picker/thumbs/ — small 320x180 JPEGs,
    // NOT the raw 20 MB wallpapers. Naming rule: <original-filename>.jpg
    //   "0001.png"      → "0001.png.jpg"
    //   "0020.jpg"      → "0020.jpg.jpg"
    //   "video.mp4"     → "000_video.mp4.jpg"
    FolderListModel {
        id: thumbModel
        folder: root.thumbDir
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp"]
        showDirs: false
        sortField: FolderListModel.Name

        // Only attempt focus when the model is fully ready — prevents the
        // infinite onCountChanged → focusCurrentWallpaper → layout shift loop.
        onStatusChanged: {
            if (status === FolderListModel.Ready) {
                root.focusCurrentWallpaper()
            }
        }
    }

    // ── Horizontal slanted gallery ──────────────────────────────────────────
    ListView {
        id: view
        anchors.fill: parent

        spacing: 0
        orientation: ListView.Horizontal
        clip: false
        cacheBuffer: 2000
        focus: true

        highlightRangeMode: ListView.StrictlyEnforceRange
        preferredHighlightBegin: (width / 2) - (root.itemWidth / 2)
        preferredHighlightEnd:   (width / 2) + (root.itemWidth / 2)
        highlightMoveDuration: 300

        model: thumbModel

        delegate: Item {
            id: delegateRoot
            width: root.itemWidth
            height: root.itemHeight
            anchors.verticalCenter: parent.verticalCenter

            readonly property bool isCurrent: ListView.isCurrentItem
            readonly property bool isVideo: fileName.startsWith("000_")

            // ── Path reconstruction ──────────────────────────────────────
            // Thumbnails are ALWAYS named <original-filename>.jpg
            // Strip "000_" prefix (video) then strip trailing ".jpg" (4 chars).
            //   "0001.png.jpg"       → "0001.png"   ✓
            //   "0020.jpg.jpg"       → "0020.jpg"   ✓
            //   "000_video.mp4.jpg"  → "video.mp4"  ✓
            readonly property string originalName: {
                let n = fileName
                if (n.startsWith("000_")) n = n.substring(4)
                return n.substring(0, n.length - 4)
            }
            readonly property string srcPath: root.srcDir + "/" + originalName

            z: isCurrent ? 10 : 1

            function pickWallpaper() {
                Wallpapers.select(srcPath, root.useDarkMode)
                GlobalStates.wallpaperSelectorOpen = false
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    view.currentIndex = index
                    delegateRoot.pickWallpaper()
                }
            }

            // ── Slanted card ─────────────────────────────────────────────
            Item {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height

                scale:   delegateRoot.isCurrent ? 1.15 : 0.95
                opacity: delegateRoot.isCurrent ? 1.0  : 0.6

                Behavior on scale   { NumberAnimation { duration: 500; easing.type: Easing.OutBack } }
                Behavior on opacity { NumberAnimation { duration: 500 } }

                transform: Matrix4x4 {
                    property real s: root.skewFactor
                    matrix: Qt.matrix4x4(1, s, 0, 0,
                                         0, 1, 0, 0,
                                         0, 0, 1, 0,
                                         0, 0, 0, 1)
                }

                // Thin coloured border — thumbnail stretched behind inner clip
                Image {
                    anchors.fill: parent
                    source: fileUrl
                    sourceSize: Qt.size(1, 1)
                    fillMode: Image.Stretch
                    asynchronous: true
                }

                // Inner content — clip + counter-skew keeps image upright
                Item {
                    anchors.fill: parent
                    anchors.margins: root.borderWidth
                    clip: true

                    Rectangle { anchors.fill: parent; color: "black" }

                    Image {
                        anchors.centerIn: parent
                        anchors.horizontalCenterOffset: -50
                        width: parent.width + (parent.height * Math.abs(root.skewFactor)) + 50
                        height: parent.height
                        fillMode: Image.PreserveAspectCrop
                        source: fileUrl
                        asynchronous: true

                        transform: Matrix4x4 {
                            property real s: -root.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0,
                                                 0, 1, 0, 0,
                                                 0, 0, 1, 0,
                                                 0, 0, 0, 1)
                        }
                    }

                    // ▶ Play badge for video wallpapers
                    Rectangle {
                        visible: delegateRoot.isVideo
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 10
                        width: 32; height: 32
                        radius: 6
                        color: "#60000000"

                        transform: Matrix4x4 {
                            property real s: -root.skewFactor
                            matrix: Qt.matrix4x4(1, s, 0, 0,
                                                 0, 1, 0, 0,
                                                 0, 0, 1, 0,
                                                 0, 0, 0, 1)
                        }

                        Canvas {
                            anchors.fill: parent
                            anchors.margins: 8
                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.fillStyle = "#EEFFFFFF"
                                ctx.beginPath()
                                ctx.moveTo(4, 0)
                                ctx.lineTo(14, 8)
                                ctx.lineTo(4, 16)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: Wallpapers
        function onChanged() {
            GlobalStates.wallpaperSelectorOpen = false
        }
    }

    Component.onCompleted: {
        view.forceActiveFocus()
        root.focusCurrentWallpaper()
    }
}
