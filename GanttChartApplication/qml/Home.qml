import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

Page {
    id: homePage

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: qsTr("Gantt.IO — Home")
                font.family: appManager.fontFamily
                font.pixelSize: Math.round((appManager.baseFontSize + 6) * (appManager.uiScale ? appManager.uiScale : 1))
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            }

            // spacer
            Item { Layout.fillWidth: true }

            ShinyButton {
                text: qsTr("Logout")
                fontFamily: appManager.fontFamily
                fontSize: appManager.baseFontSize
                onClicked: backend.logout()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Qt.rgba(1,1,1,0.02)
            radius: 8

            Text {
                anchors.centerIn: parent
                text: qsTr("Welcome to the Home screen")
                font.pixelSize: Math.round(appManager.baseFontSize * (appManager.uiScale ? appManager.uiScale : 1))
                color: "#444"
            }
        }
    }
}
