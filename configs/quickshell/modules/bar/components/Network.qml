import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4

    property string ssid:     ""
    property string connType: "none"
    property bool   _found:   false

    Process {
        id: nmcli
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device", "status"]
        running: true

        stdout: SplitParser {
            onRead: line => {
                if (root._found) return
                const parts = line.split(":")
                if (parts.length >= 3 && parts[1] === "connected") {
                    root.connType = parts[0].includes("wifi") ? "wifi" : "ethernet"
                    root.ssid     = parts.slice(2).join(":")
                    root._found   = true
                }
            }
        }

        onRunningChanged: if (!running) root._found = false
    }

    Timer {
        interval: 15000
        running: true
        repeat: true
        onTriggered: { root._found = false; nmcli.running = false; nmcli.running = true }
    }

    Text {
        text: root.connType === "ethernet" ? "󰈀" :
              root.connType === "wifi"      ? "󰖩" : "󰖪"
        color: root.connType === "none" ? "#585b70" : "#89dceb"
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        Behavior on color { ColorAnimation { duration: 200 } }
    }

    Text {
        text: root.ssid
        color: "#a6adc8"
        font.pixelSize: 12
        visible: root.ssid.length > 0
        elide: Text.ElideRight
        Layout.maximumWidth: 100
    }
}
