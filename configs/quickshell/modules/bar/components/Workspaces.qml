import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 6

    property color accentColor: "#cba6f7"

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            required property HyprlandWorkspace modelData

            readonly property bool active:   modelData.id === Hyprland.focusedWorkspace?.id
            readonly property bool occupied: modelData.toplevels.count > 0

            width:  8
            height: 8
            radius: 4
            color:  active   ? root.accentColor :
                    occupied ? "#6c7086" : "#313244"
            scale:  active ? 1.45 : 1.0

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: modelData.activate()
            }
        }
    }
}
