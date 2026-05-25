pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property string distroName: "Linux"
    property string distroId: "linux"
    property string kernelVersion: "Unknown"
    property string hostName: "localhost"
    property string userName: Quickshell.env("USER") || "User"

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
}
