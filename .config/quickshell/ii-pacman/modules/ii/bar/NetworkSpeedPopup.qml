import qs.modules.common
import qs.modules.common.widgets
import qs.services
import "./cards"
import QtQuick
import QtQuick.Layouts

StyledPopup {
    id: root
    popupRadius: Appearance.rounding.large

    function formatSpeed(bytesPerSecond) {
        if (bytesPerSecond < 1024) return bytesPerSecond.toFixed(0) + " B/s";
        if (bytesPerSecond < 1024 * 1024) return (bytesPerSecond / 1024).toFixed(1) + " KB/s";
        if (bytesPerSecond < 1024 * 1024 * 1024) return (bytesPerSecond / (1024 * 1024)).toFixed(1) + " MB/s";
        return (bytesPerSecond / (1024 * 1024 * 1024)).toFixed(1) + " GB/s";
    }

    function formatTotal(bytes) {
        if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + " KB";
        if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)).toFixed(1) + " MB";
        return (bytes / (1024 * 1024 * 1024)).toFixed(1) + " GB";
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        HeroCard {
            id: networkHero
            icon: Network.ethernet ? "lan" : "wifi"
            title: Network.ethernet ? Translation.tr("Ethernet") : Translation.tr("Wi-Fi")
            subtitle: Network.networkName || Translation.tr("Connected")
            
            compactMode: true
            adaptiveWidth: true
            
            // Show signal strength in the pill if wifi
            pillText: !Network.ethernet ? (Network.networkStrength + "%") : ""
            pillIcon: !Network.ethernet ? "signal_wifi_4_bar" : ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            InfoPill {
                icon: "download"
                text: Translation.tr("Download: ") + formatSpeed(ResourceUsage.networkDownloadSpeed)
                containerColor: Appearance.colors.colPrimaryContainer
                shapeColor: Appearance.colors.colPrimary
                symbolColor: Appearance.colors.colOnPrimary
                textColor: Appearance.colors.colOnPrimaryContainer
            }

            InfoPill {
                icon: "upload"
                text: Translation.tr("Upload: ") + formatSpeed(ResourceUsage.networkUploadSpeed)
                containerColor: Appearance.colors.colSecondaryContainer
                shapeColor: Appearance.colors.colSecondary
                symbolColor: Appearance.colors.colOnSecondary
                textColor: Appearance.colors.colOnSecondaryContainer
            }

            InfoPill {
                icon: "data_usage"
                text: Translation.tr("Total: ") + formatTotal(ResourceUsage.networkDownloadTotal + ResourceUsage.networkUploadTotal)
                containerColor: Appearance.colors.colTertiaryContainer
                shapeColor: Appearance.colors.colTertiary
                symbolColor: Appearance.colors.colOnTertiary
                textColor: Appearance.colors.colOnTertiaryContainer
            }
        }
    }
}
