import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 8

    property var now: new Date()

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: now = new Date()
    }

    Text {
        text: Qt.formatDateTime(now, "hh:mm")
        color: "#cdd6f4"
        font.pixelSize: 13
        font.bold: true
    }

    Text {
        text: Qt.formatDateTime(now, "ddd, MMM d")
        color: "#7f849c"
        font.pixelSize: 12
    }
}
