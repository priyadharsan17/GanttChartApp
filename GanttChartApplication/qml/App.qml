import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("GanttChart Application")
    color: appManager.primaryColor

    // Base design resolution — change to match your designer's artboard.
    property real designWidth: appManager.width
    property real designHeight: appManager.height

    property real uiScale: Math.max(width / designWidth, height / designHeight)

    // Keep the Python-side appManager in sync with actual window metrics
    Component.onCompleted: {
        appManager.width = width
        appManager.height = height
        if (appManager.hasOwnProperty('uiScale')) {
            appManager.uiScale = uiScale
        }
    }
    onWidthChanged: { appManager.width = width; if (appManager.hasOwnProperty('uiScale')) appManager.uiScale = uiScale }
    onHeightChanged: { appManager.height = height; if (appManager.hasOwnProperty('uiScale')) appManager.uiScale = uiScale }

    // A top-level container sized to the design resolution then scaled.
    // This keeps layout coordinates simple (designer-friendly) while
    // scaling the full UI to fit the current screen.
    Rectangle {
        id: viewport
        anchors.fill: parent
        color: "transparent"

        Item {
            id: scaler
            width: designWidth
            height: designHeight
            scale: uiScale
            transformOrigin: Item.Center

            // Center the scaled content inside the window (will crop if uiScale>1)
            anchors.centerIn: parent

            // StackView provides push/pop navigation for pages (login, dashboard)
            StackView {
                id: stackView
                anchors.fill: parent
                initialItem: "Login.qml"
            }
            
            // Listen for login/logout events and navigate the StackView centrally
            Connections {
                target: loginManager
                function onLoginResult(success, message) {
                    if (success) {
                        // replace the current Login page with Home so users can't go back
                        stackView.replace(stackView.currentItem, "Home.qml")
                    }
                }
                function onLogoutRequested() {
                    // navigate back to login (replace current with Login)
                    stackView.replace(stackView.currentItem, "Login.qml")
                }
            }
        }
    }
}
