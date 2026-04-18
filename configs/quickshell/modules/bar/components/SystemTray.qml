import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 4

    Repeater {
        model: SystemTray.items

        Item {
            required property SystemTrayItem modelData

            width: 18
            height: 18

            Image {
                anchors.fill: parent
                source: parent.modelData.icon
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton)
                        parent.modelData.activate()
                    else if (parent.modelData.hasMenu)
                        parent.modelData.menu.popup()
                }
            }
        }
    }
}
