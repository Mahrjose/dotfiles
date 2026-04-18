import Quickshell
import QtQuick

Text {
    text: "⏻"
    color: hovered ? "#f38ba8" : "#6c7086"
    font.pixelSize: 14

    property bool hovered: false
    Behavior on color { ColorAnimation { duration: 150 } }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered: parent.hovered = true
        onExited:  parent.hovered = false
        onClicked: Quickshell.execDetached(["bash", "-c",
            "rofi -show menu -modi 'menu:~/.config/rofi/scripts/power-menu.sh'"])
    }
}
