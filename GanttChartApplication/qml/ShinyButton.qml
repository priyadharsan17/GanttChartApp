import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Rectangle {
    id: root
    property alias text: label.text
    property string fontFamily: "Segoe UI"
    property int fontSize: 14
    property color bg: "#1976D2"
    signal clicked()

    // Do not force Layout.fillWidth here so callers can decide layout behavior.
    // Provide sensible implicit size so the button is usable without explicit sizing.
    implicitWidth: 160
    implicitHeight: 44
    radius: 8
    color: bg
    border.width: 0

    // Press effect
    transform: Scale { id: pressScale; xScale: 1.0; yScale: 1.0 }

    Text {
        id: label
        anchors.centerIn: parent
        color: "white"
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
        horizontalAlignment: Text.AlignHCenter
    }

    // shining overlay
    Rectangle {
        id: shine
        color: "white"
        opacity: 0.0
        radius: root.radius
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width * 0.35
        x: -width
        y: 0
        rotation: -20
        z: 1
        smooth: true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPressed: { pressScale.xScale = 0.98; pressScale.yScale = 0.98 }
        onReleased: { pressScale.xScale = 1.0; pressScale.yScale = 1.0 }
        onClicked: root.clicked()
    }

    // subtle gradient effect by overlaying a semi-transparent rounded rect
    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: "transparent"
        border.color: "transparent"
    }
}
