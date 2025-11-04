import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Item {
    id: root
    property alias text: input.text
    property alias cursorPosition: input.cursorPosition
    property string placeholderText: ""
    property string fontFamily: "Segoe UI"
    // Default font size; components can override. We multiply by appManager.uiScale
    // at render time so fonts scale with the UI. Fall back to 1.0 if uiScale missing.
    property int fontSize: 14
    property int echoMode: TextInput.Normal
    signal accepted()

    implicitWidth: 280
    implicitHeight: Math.round(44 * (appManager.uiScale ? appManager.uiScale : 1))

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 8
        color: "transparent"
        border.width: 1
        // change border color when input has focus
        border.color: input.activeFocus ? Qt.rgba(0.22,0.55,0.9,1) : Qt.rgba(0.78,0.78,0.78,1)
    }

    // core text input
    TextInput {
        id: input
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.right: clearArea.left
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter
    font.family: root.fontFamily
    font.pixelSize: Math.round(root.fontSize * (appManager.uiScale ? appManager.uiScale : 1))
        echoMode: root.echoMode
        focus: false
        verticalAlignment: TextInput.AlignVCenter
        selectByMouse: true
        padding: 0
    // TextInput (QtQuick) has no 'background' property; keep default
        Keys.onReturnPressed: root.accepted()
    }

    // placeholder text
    Text {
        id: placeholder
        anchors.left: input.left
        anchors.verticalCenter: input.verticalCenter
        text: root.placeholderText
        color: Qt.rgba(0.52,0.52,0.52,1)
    font.family: root.fontFamily
    font.pixelSize: Math.round(root.fontSize * (appManager.uiScale ? appManager.uiScale : 1))
        opacity: input.text.length > 0 ? 0.0 : 1.0
        z: 1
        MouseArea { anchors.fill: parent; onClicked: input.forceActiveFocus() }
    }

    // clear button area
    Item {
        id: clearArea
        width: 28
        anchors.right: parent.right
        anchors.rightMargin: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: clearX
            anchors.centerIn: parent
            visible: input.text.length > 0
            text: "✕"
            color: Qt.rgba(0.5,0.5,0.5,1)
            font.pixelSize: Math.max(8, Math.round((root.fontSize - 2) * (appManager.uiScale ? appManager.uiScale : 1)))
        }

        MouseArea {
            anchors.fill: parent
            onClicked: { input.text = ""; input.forceActiveFocus() }
            hoverEnabled: true
        }
    }

    // Expose focus via input.activeFocus; callers can bind to input.activeFocus if needed
}
