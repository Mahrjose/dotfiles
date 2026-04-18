import Quickshell
import Quickshell.Bluetooth
import QtQuick

Text {
    readonly property bool btEnabled:  Bluetooth.enabled
    readonly property bool btConnected: Bluetooth.devices.values.some(d => d.connected)

    text: "󰂯"
    color: !btEnabled   ? "#313244" :
            btConnected ? "#89b4fa" : "#6c7086"
    font.pixelSize: 15
    font.family: "JetBrainsMono Nerd Font"

    Behavior on color { ColorAnimation { duration: 200 } }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Bluetooth.enabled = !Bluetooth.enabled
    }
}
