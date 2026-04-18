import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4

    // Pipewire binding — may be null on startup
    readonly property var  pwSink:  Pipewire.defaultAudioSink
    readonly property var  pwAudio: pwSink?.audio ?? null

    // Fallback values read via pactl
    property real  vol:   pwAudio ? pwAudio.volume : fallbackVol
    property bool  muted: pwAudio ? pwAudio.muted  : false
    property real  fallbackVol: 1.0

    Process {
        id: pactl
        command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+(?=%)' | head -1"]
        running: !root.pwAudio   // only run if Pipewire not available

        stdout: SplitParser {
            onRead: line => {
                const n = parseInt(line.trim())
                if (!isNaN(n)) root.fallbackVol = n / 100.0
            }
        }
    }

    Text {
        text: root.muted      ? "󰝟" :
              root.vol > 0.66 ? "󰕾" :
              root.vol > 0.33 ? "󰖀" : "󰕿"
        color: root.muted ? "#585b70" : "#89b4fa"
        font.pixelSize: 15
        font.family: "JetBrainsMono Nerd Font"
        Behavior on color { ColorAnimation { duration: 150 } }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (root.pwAudio) root.pwAudio.muted = !root.pwAudio.muted
            }
        }
    }

    Text {
        text: root.muted ? "muted" : Math.round(root.vol * 100) + "%"
        color: root.muted ? "#585b70" : "#a6adc8"
        font.pixelSize: 12
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}
