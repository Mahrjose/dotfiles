import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4

    property real   pct:      100
    property string status:   "Unknown"  // Charging, Discharging, Full, Not charging
    property bool   charging: status === "Charging"

    // Read from sysfs directly — works without UPower
    Process {
        id: batReader
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity; cat /sys/class/power_supply/BAT0/status"]
        running: true

        stdout: SplitParser {
            property int lineNum: 0
            onRead: line => {
                const s = line.trim()
                if (lineNum === 0) { const n = parseInt(s); if (!isNaN(n)) root.pct = n }
                else               { root.status = s }
                lineNum++
            }
        }
        onRunningChanged: if (!running) {
            // reset line counter for next run
            const parser = stdout
            if (parser) parser.lineNum = 0
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: batReader.running = false, batReader.running = true
    }

    Text {
        text: root.charging     ? "󰂄" :
              root.pct > 90     ? "󰁹" :
              root.pct > 75     ? "󰂀" :
              root.pct > 60     ? "󰁿" :
              root.pct > 45     ? "󰁾" :
              root.pct > 30     ? "󰁽" :
              root.pct > 20     ? "󰁼" :
              root.pct > 10     ? "󰁺" : "󰂃"
        color: root.charging    ? "#a6e3a1" :
               root.pct < 20   ? "#f38ba8" :
               root.pct < 40   ? "#fab387" : "#a6adc8"
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        Behavior on color { ColorAnimation { duration: 500 } }
    }

    Text {
        text: Math.round(root.pct) + "%"
        color: root.pct < 20 ? "#f38ba8" : "#a6adc8"
        font.pixelSize: 12
        Behavior on color { ColorAnimation { duration: 500 } }
    }
}
