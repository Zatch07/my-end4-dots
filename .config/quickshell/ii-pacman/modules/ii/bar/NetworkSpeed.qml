import qs.modules.common
import qs.modules.common.widgets
import qs.services
import qs
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: networkLayout.implicitWidth + 6
    implicitHeight: Appearance.sizes.barHeight

    // Display modes: 0=total, 1=download, 2=upload, 3=both
    property int displayMode: 0

    // Helper function to format network speed
    function formatSpeed(bytesPerSecond) {
        if (bytesPerSecond < 1024) {
            return bytesPerSecond.toFixed(0) + " B/s";
        } else if (bytesPerSecond < 1024 * 1024) {
            return (bytesPerSecond / 1024).toFixed(1) + " KB/s";
        } else if (bytesPerSecond < 1024 * 1024 * 1024) {
            return (bytesPerSecond / (1024 * 1024)).toFixed(1) + " MB/s";
        } else {
            return (bytesPerSecond / (1024 * 1024 * 1024)).toFixed(1) + " GB/s";
        }
    }

    function getDisplayText() {
        var downloadSpeed = ResourceUsage.networkDownloadSpeed;
        var uploadSpeed = ResourceUsage.networkUploadSpeed;
        var totalSpeed = downloadSpeed + uploadSpeed;

        switch (displayMode) {
        case 0: // Total speed
            return formatSpeed(totalSpeed);
        case 1: // Download only
            return "↓ " + formatSpeed(downloadSpeed);
        case 2: // Upload only
            return "↑ " + formatSpeed(uploadSpeed);
        case 3: // Both (dual row)
            return ""; // Handled separately
        default:
            return formatSpeed(totalSpeed);
        }
    }

    RowLayout {
        id: networkLayout
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 6

        // Single line display (modes 0, 1, 2)
        Item {
            id: singleLineContainer
            visible: displayMode !== 3
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: singleLineText.implicitWidth
            implicitHeight: singleLineText.implicitHeight
            StyledText {
                id: singleLineText
                anchors.centerIn: parent
                anchors.verticalCenterOffset: 1
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colOnLayer1
                text: getDisplayText()
            }
        }

        // Side by side display (mode 3)
        RowLayout {
            visible: displayMode === 3
            spacing: 4

            Item {
                implicitWidth: downloadText.implicitWidth
                implicitHeight: downloadText.implicitHeight
                Layout.alignment: Qt.AlignVCenter
                StyledText {
                    id: downloadText
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 1
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                    text: "↓ " + formatSpeed(ResourceUsage.networkDownloadSpeed)
                }
            }

            Item {
                implicitWidth: uploadText.implicitWidth
                implicitHeight: uploadText.implicitHeight
                Layout.alignment: Qt.AlignVCenter
                StyledText {
                    id: uploadText
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: 1
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colOnLayer1
                    text: "↑ " + formatSpeed(ResourceUsage.networkUploadSpeed)
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton
        onClicked: {
            displayMode = (displayMode + 1) % 4;
        }
    }

    NetworkSpeedPopup {
        hoverTarget: mouseArea
    }
}
