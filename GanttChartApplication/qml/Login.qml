import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {
    id: page

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        width: Math.min(parent.width * 0.5, 480)

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 140
            radius: 8
            color: Qt.rgba(1,1,1,0.0)
            Text {
                    text: qsTr("GANTT.IO")
                    font.family: "Ethnocentric"
                    font.pixelSize: appManager.baseFontSize + 54
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    color: "#333333"
                }
        }

        CustomTextField {
            id: usernameField
            placeholderText: qsTr("Username")
            fontFamily: appManager.fontFamily
            fontSize: appManager.baseFontSize
            Layout.fillWidth: true
        }

        CustomTextField {
            id: passwordField
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            fontFamily: appManager.fontFamily
            fontSize: appManager.baseFontSize
            Layout.fillWidth: true
        }

        ShinyButton {
            text: qsTr("Sign in")
            Layout.fillWidth: true
            fontFamily: appManager.fontFamily
            fontSize: appManager.baseFontSize
            onClicked: {
                loginManager.login(usernameField.text, passwordField.text)
            }
        }

        Text {
            id: statusText
            text: ""
            color: "#b00020"
            font.family: appManager.fontFamily
            font.pixelSize: appManager.baseFontSize - 2
            horizontalAlignment: Text.AlignHCenter
            width: parent.width
            Layout.alignment: Qt.AlignHCenter
        }

        Connections {
            target: loginManager
            function onLoginResult(success, message) {
                if (success) {
                    statusText.color = "#1b5e20"
                    statusText.text = message
                } else {
                    statusText.color = "#b00020"
                    statusText.text = message
                }
            }
        }
    }
}
