import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 6

    readonly property MprisPlayer player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null

    visible: player !== null
    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Text {
        text: "󰎇"
        color: "#cba6f7"
        font.pixelSize: 13
        font.family: "JetBrainsMono Nerd Font"
    }

    Text {
        readonly property string track:  parent.player?.trackTitle  ?? ""
        readonly property string artist: parent.player?.trackArtist ?? ""
        text: {
            const full = artist.length > 0 ? artist + " - " + track : track
            return full.length > 35 ? full.slice(0, 32) + "..." : full
        }
        color: "#a6adc8"
        font.pixelSize: 12
    }

    Text {
        text: "󰒮"
        color: "#6c7086"
        font.pixelSize: 13
        font.family: "JetBrainsMono Nerd Font"
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.parent.player?.previous() }
    }

    Text {
        text: parent.player?.playbackState === MprisPlaybackState.Playing ? "󰏤" : "󰐊"
        color: "#cdd6f4"
        font.pixelSize: 13
        font.family: "JetBrainsMono Nerd Font"
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.parent.player?.togglePlaying() }
    }

    Text {
        text: "󰒭"
        color: "#6c7086"
        font.pixelSize: 13
        font.family: "JetBrainsMono Nerd Font"
        MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.parent.player?.next() }
    }
}
