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

            // Loader-based navigation with smooth transitions
            Item {
                id: navRoot
                anchors.fill: parent

                // current and next loaded items for cross-fade/slide
                Item {
                    id: currentHolder
                    anchors.fill: parent
                    visible: true
                }

                Item {
                    id: nextHolder
                    anchors.fill: parent
                    visible: false
                }

                Loader {
                    id: currentLoader
                    anchors.fill: parent
                    source: "Login.qml"
                    asynchronous: true
                    onLoaded: {
                        // parent the loaded item into the holder for consistent sizing
                        if (item) {
                            item.parent = currentHolder
                            item.anchors.fill = currentHolder
                        }
                    }
                }

                Loader {
                    id: nextLoader
                    anchors.fill: parent
                    asynchronous: true
                    visible: false
                    onLoaded: {
                        if (item) {
                            item.parent = nextHolder
                            item.anchors.fill = nextHolder
                        }
                    }
                }

                // predeclared parallel animation used for page transitions
                ParallelAnimation {
                    id: pageSwapAnim
                    // animate current out
                    PropertyAnimation { id: curXAnim; target: currentHolder; property: "x"; to: -root.width; duration: 320; easing.type: Easing.InOutQuad }
                    NumberAnimation { id: curOpacityAnim; target: currentHolder; property: "opacity"; to: 0; duration: 320 }
                    // animate next in
                    PropertyAnimation { id: nextXAnim; target: nextHolder; property: "x"; from: root.width; to: 0; duration: 320; easing.type: Easing.InOutQuad }
                    NumberAnimation { id: nextOpacityAnim; target: nextHolder; property: "opacity"; to: 1; duration: 320 }

                    onStopped: {
                        // move next content into currentLoader by swapping sources
                        currentLoader.source = nextLoader.source
                        // reset holders
                        currentHolder.x = 0; currentHolder.opacity = 1; currentHolder.visible = true
                        nextHolder.x = 0; nextHolder.opacity = 1; nextHolder.visible = false
                        nextLoader.source = ""
                    }
                }

                function navigateTo(qmlSource) {
                    // load new page into nextLoader and perform a cross-fade
                    if (!qmlSource || qmlSource === currentLoader.source) return
                    nextLoader.source = qmlSource
                    nextLoader.visible = true
                    nextHolder.opacity = 0
                    nextHolder.visible = true

                    // animate: slide current left while fading out, fade-in next
                    // position next holder off-screen to the right and reset opacities
                    nextHolder.x = root.width
                    nextHolder.opacity = 0
                    currentHolder.x = 0
                    currentHolder.opacity = 1
                    // start the predeclared animation
                    pageSwapAnim.start()
                }

                // Listen for login/logout events and navigate centrally
                Connections {
                    target: loginManager
                    function onLoginResult(success, message) {
                        if (success) {
                            // move to Home and prevent going back
                            // delegate to Python-side screenLoader so history is tracked
                            if (screenLoader && screenLoader.navigateTo) screenLoader.navigateTo("Home.qml")
                        }
                    }
                    function onLogoutRequested() {
                        if (screenLoader && screenLoader.navigateTo) screenLoader.navigateTo("Login.qml")
                    }
                }

                // Listen for navigation requests from Python and perform the visual transition
                Connections {
                    target: screenLoader
                    function onNavigationRequested(source) {
                        // call the existing JS navigation function which performs the loader swap + animation
                        navRoot.navigateTo(source)
                    }
                }
            }
        }
    }
}
