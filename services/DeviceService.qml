pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Software
    property string distroName: "Linux"
    property string distroId: "linux"
    property string kernelVersion: "Unknown"
    property string hostName: "localhost"
    property string userName: Quickshell.env("USER") || "User"
    
    // Hardware
    property real cpuUsage: 0.0
    property real ramUsage: 0.0
    property real ramTotalGb: 0.0 // Total RAM
    property real ramUsedGb: 0.0  // Used RAM
    property var _prevCpu: ({ total: 0, idle: 0 })

    Process {
        command: ["cat", "/etc/os-release"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                let line = data.trim();

                if (line.startsWith("PRETTY_NAME=")) {
                    root.distroName = line.split("=")[1].replace(/"/g, "");
                    console.info("[Device Service] Found Distro Name: " +root.distroName)
                }
                if (line.startsWith("ID=")) {
                    root.distroId = line.split("=")[1].replace(/"/g, "");
                    console.info("[Device Service] Found Distro ID: " +root.distroId)
                }
            }
        }
    }

    Process {
        command: ["uname", "-r"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    root.kernelVersion = data.trim();
                    console.info("[Device Service] Found Kernel: " + root.kernelVersion);
                }
            }
        }
    }

    Process {
        command: ["cat", "/etc/hostname"]
        running: true

        stdout: SplitParser {
            onRead: (data) => {
                if (data.trim() !== "") {
                    root.hostName = data.trim();
                    console.info("[Device Service] Found Hostname: " + root.hostName);
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            procStatFile.reload();
            procMemFile.reload();
        }
    }

    FileView {
        id: procStatFile
        path: "/proc/stat"
        onLoaded: {
            let lines = procStatFile.text().split("\n");
            if (lines.length === 0) return;

            let cpuLine = lines[0];
            if (!cpuLine.startsWith("cpu ")) return;

            let parts = cpuLine.trim().split(/\s+/).slice(1).map(Number);
            if (parts.length < 4) return;

            let user = parts[0], nice = parts[1], system = parts[2], idle = parts[3];
            let iowait = parts[4] || 0, irq = parts[5] || 0, softirq = parts[6] || 0, steal = parts[7] || 0;

            let totalIdle = idle + iowait;
            let totalNonIdle = user + nice + system + irq + softirq + steal;
            let total = totalIdle + totalNonIdle;

            if (root._prevCpu.total > 0) {
                let totalDiff = total - root._prevCpu.total;
                let idleDiff = totalIdle - root._prevCpu.idle;

                if (totalDiff > 0) {
                    root.cpuUsage = Math.min(1.0, Math.max(0.0, (totalDiff - idleDiff) / totalDiff));
                }
            }

            root._prevCpu = { total: total, idle: totalIdle };
        }
    }

    FileView {
        id: procMemFile
        path: "/proc/meminfo"
        onLoaded: {
            let text = procMemFile.text();
            let totalKb = 0;
            let availKb = 0;

            let matchTotal = text.match(/MemTotal:\s+(\d+)\s+kB/);
            let matchAvail = text.match(/MemAvailable:\s+(\d+)\s+kB/);

            if (matchTotal) totalKb = parseInt(matchTotal[1], 10);
            if (matchAvail) availKb = parseInt(matchAvail[1], 10);

            if (totalKb > 0) {
                let usedKb = totalKb - availKb;
                root.ramTotalGb = totalKb / 1048576;
                root.ramUsedGb = usedKb / 1048576;
                root.ramUsage = Math.min(1.0, Math.max(0.0, usedKb / totalKb));
            }
        }
    }
}
