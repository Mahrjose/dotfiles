import Quickshell
import Quickshell.Hyprland
import QtQuick

Text {
    readonly property string title: Hyprland.focusedToplevel?.title ?? ""

    text: title.length > 60 ? title.slice(0, 57) + "..." : title
    color: "#a6adc8"
    font.pixelSize: 12
    elide: Text.ElideRight
    maximumLineCount: 1

    Behavior on opacity { NumberAnimation { duration: 150 } }
    opacity: title.length > 0 ? 1 : 0
}
