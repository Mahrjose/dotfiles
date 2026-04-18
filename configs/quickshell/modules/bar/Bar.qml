import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "components"

PanelWindow {
    id: root

    property color accentColor: "#cba6f7"
    property bool  isDark: true

    anchors { top: true; left: true; right: true }
    implicitHeight: 40
    color: "transparent"    // Hyprland blur handles the background

    // Reusable pill container
    component Pill: Rectangle {
        default property alias content: pillLayout.data
        property int hpad: 10
        property int vpad: 0

        color: "#cc11111b"
        radius: height / 2
        implicitHeight: 28
        implicitWidth: pillLayout.implicitWidth + hpad * 2

        RowLayout {
            id: pillLayout
            anchors.centerIn: parent
            spacing: 6
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        spacing: 6

        // ── Left ──────────────────────────────────────────────────────────
        Pill {
            Workspaces { accentColor: root.accentColor }
        }

        Pill {
            visible: activeWin.title.length > 0
            implicitWidth: Math.min(activeWin.implicitWidth + 20, 300)
            ActiveWindow { id: activeWin }
        }

        Item { Layout.fillWidth: true }

        // ── Center ────────────────────────────────────────────────────────
        Pill {
            hpad: 14
            Clock {}
        }

        Item { Layout.fillWidth: true }

        // ── Right ─────────────────────────────────────────────────────────
        Pill {
            visible: media.visible
            MediaPlayer { id: media }
        }

        Pill {
            RowLayout {
                spacing: 8
                Network {}
                Rectangle { width: 1; height: 14; color: "#30ffffff" }
                Bluetooth {}
            }
        }

        Pill {
            RowLayout {
                spacing: 8
                Volume {}
                Rectangle { width: 1; height: 14; color: "#30ffffff" }
                Battery {}
            }
        }

        Pill {
            SystemTray {}
        }

        Pill {
            hpad: 8
            PowerButton {}
        }
    }
}
