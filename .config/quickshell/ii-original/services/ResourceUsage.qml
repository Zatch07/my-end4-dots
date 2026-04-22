pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io

/**
 * Hybrid Resource usage service with RAM, Swap, CPU, GPU, and Network monitoring.
 * Supports AMD/Intel CPUs and AMD/Nvidia GPUs.
 */
Singleton {
    id: root
    property real memoryTotal: 1
    property real memoryFree: 0
    property real memoryUsed: memoryTotal - memoryFree
    property real memoryUsedPercentage: memoryUsed / memoryTotal
    property real diskTotal: 1
    property real diskFree: 0
    property real diskUsed: 0
    property real diskUsedPercentage: diskTotal > 0 ? (diskUsed / diskTotal) : 0
    property real swapTotal: 1
    property real swapFree: 0
    property real swapUsed: swapTotal - swapFree
    property real swapUsedPercentage: swapTotal > 0 ? (swapUsed / swapTotal) : 0
    
    // CPU
    property real cpuUsage: 0
    property var previousCpuStats
    property real cpuTemp: 0
    property real cpuFreqMhz: 0
    property string cpuModel: "--"
    
    // GPU
    property real gpuUsage: 0
    property real gpuPowerW: 0
    property real gpuTemp: 0
    property string gpuModel: "--"

    // Network
    property real networkDownloadSpeed: 0
    property real networkUploadSpeed: 0
    property real networkDownloadTotal: 0
    property real networkUploadTotal: 0
    property var previousNetworkStats: null

    property string maxAvailableMemoryString: kbToGbString(root.memoryTotal)
    property string maxAvailableSwapString: kbToGbString(root.swapTotal)
    property string maxAvailableCpuString: "--"

    readonly property int historyLength: Config?.options.resources.historyLength ?? 60
    property list<real> cpuUsageHistory: []
    property list<real> memoryUsageHistory: []
    property list<real> swapUsageHistory: []

    function kbToGbString(kb) {
        return (kb / (1024 * 1024)).toFixed(1) + " GB";
    }

    function updateMemoryUsageHistory() {
        memoryUsageHistory = [...memoryUsageHistory, memoryUsedPercentage]
        if (memoryUsageHistory.length > historyLength) memoryUsageHistory.shift()
    }
    function updateSwapUsageHistory() {
        swapUsageHistory = [...swapUsageHistory, swapUsedPercentage]
        if (swapUsageHistory.length > historyLength) swapUsageHistory.shift()
    }
    function updateCpuUsageHistory() {
        cpuUsageHistory = [...cpuUsageHistory, cpuUsage]
        if (cpuUsageHistory.length > historyLength) cpuUsageHistory.shift()
    }
    function updateHistories() {
        updateMemoryUsageHistory()
        updateSwapUsageHistory()
        updateCpuUsageHistory()
    }

    Timer {
        id: mainTimer
        interval: 1
        running: true 
        repeat: true
        onTriggered: {
            // Reload files
            fileMeminfo.reload()
            fileStat.reload()
            fileNetDev.reload()

            // Parse memory and swap
            const textMeminfo = fileMeminfo.text()
            memoryTotal = Number(textMeminfo.match(/MemTotal: *(\d+)/)?.[1] ?? 1)
            memoryFree = Number(textMeminfo.match(/MemAvailable: *(\d+)/)?.[1] ?? 0)
            swapTotal = Number(textMeminfo.match(/SwapTotal: *(\d+)/)?.[1] ?? 1)
            swapFree = Number(textMeminfo.match(/SwapFree: *(\d+)/)?.[1] ?? 0)

            // Parse CPU usage
            const textStat = fileStat.text()
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/)
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number)
                const total = stats.reduce((a, b) => a + b, 0)
                const idle = stats[3]
                if (previousCpuStats) {
                    const totalDiff = total - previousCpuStats.total
                    const idleDiff = idle - previousCpuStats.idle
                    cpuUsage = totalDiff > 0 ? (1 - idleDiff / totalDiff) : 0
                }
                previousCpuStats = { total, idle }
            }

            // Parse Network Speed
            const netLines = fileNetDev.text().split('\n')
            let totalRx = 0, totalTx = 0
            for (let i = 2; i < netLines.length; i++) {
                const line = netLines[i].trim()
                if (line.startsWith('en') || line.startsWith('wl')) {
                    const cols = line.split(/[:\s]+/)
                    totalRx += Number(cols[1]) || 0
                    totalTx += Number(cols[9]) || 0
                }
            }
            if (root.previousNetworkStats !== null) {
                const secs = Math.max(0.1, mainTimer.interval / 1000.0)
                root.networkDownloadSpeed = Math.max(0, (totalRx - root.previousNetworkStats.rx) / secs)
                root.networkUploadSpeed = Math.max(0, (totalTx - root.previousNetworkStats.tx) / secs)
            }
            root.networkDownloadTotal = totalRx
            root.networkUploadTotal = totalTx
            root.previousNetworkStats = { rx: totalRx, tx: totalTx }

            root.updateHistories()
            interval = Config.options?.resources?.updateInterval ?? 3000
        }
    }

    FileView { id: fileMeminfo; path: "/proc/meminfo" }
    FileView { id: fileStat; path: "/proc/stat" }
    FileView { id: fileNetDev; path: "/proc/net/dev" }

    // Procs for Models
    Process {
        id: cpuModelProc
        command: ["bash", "-c", "grep -m1 'model name' /proc/cpuinfo | sed 's/model name\\s*:\\s*//'"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.cpuModel = text.trim() }
    }
    Process {
        id: gpuModelProc
        command: ["bash", "-c", "nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null || (lspci | grep -i 'vga\\|3d' | head -1 | sed 's/.*: //')"]
        running: true
        stdout: StdioCollector { onStreamFinished: root.gpuModel = text.trim() }
    }

    // Disk Space
    Process {
        command: ["bash", "-c", "while true; do df -B1 / | awk 'NR==2{print $2, $3, $4}'; sleep 10; done"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/\s+/)
                if (parts.length >= 3) {
                    root.diskTotal = Number(parts[0])
                    root.diskUsed = Number(parts[1])
                    root.diskFree = Number(parts[2])
                }
            }
        }
    }

    // Comprehensive Hardware Monitor
    Process {
        id: hardwareMonitorProc
        environment: ({ LANG: "C", LC_ALL: "C" })
        command: ["bash", "-c", 
            "while true; do " + 
            "cpu_freq=$(awk '/cpu MHz/ {s+=$4; n++} END {if(n>0) print int(s/n)}' /proc/cpuinfo); " +
            "cpu_temp=$(for d in /sys/class/hwmon/hwmon*; do if grep -qE 'k10temp|coretemp|zenpower' \"$d/name\" 2>/dev/null; then cat \"$d/temp1_input\" 2>/dev/null; break; fi; done || echo 0); " +
            "if command -v nvidia-smi >/dev/null 2>&1; then " +
            "  gpu_stats=$(nvidia-smi --query-gpu=utilization.gpu,power.draw,temperature.gpu --format=csv,noheader,nounits 2>/dev/null || echo \"0, 0, 0\"); " +
            "else " +
            "  gpu_u=$(cat /sys/class/hwmon/hwmon*/device/gpu_busy_percent 2>/dev/null | head -1 || echo 0); " +
            "  gpu_p=$(cat /sys/class/hwmon/hwmon*/power1_average 2>/dev/null | awk '{print $1/1000000}' | head -1 || echo 0); " +
            "  gpu_t=$(cat /sys/class/hwmon/hwmon*/temp1_input 2>/dev/null | head -1 | awk '{print $1/1000}' || echo 0); " +
            "  gpu_stats=\"$gpu_u, $gpu_p, $gpu_t\"; " +
            "fi; " +
            "echo \"$cpu_freq $cpu_temp $gpu_stats\"; " + 
            "sleep 3; done"
        ]
        running: true
        stdout: SplitParser {
            onRead: data => {
                const parts = data.trim().split(/[\s,]+/)
                if (parts.length >= 5) {
                    root.cpuFreqMhz = Number(parts[0])
                    root.cpuTemp = Number(parts[1]) / (parts[1] > 1000 ? 1000 : 1)
                    root.gpuUsage = Number(parts[2]) / 100
                    root.gpuPowerW = Number(parts[3])
                    root.gpuTemp = Number(parts[4])
                }
            }
        }
    }
}
