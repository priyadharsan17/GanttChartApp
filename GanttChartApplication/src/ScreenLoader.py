from PySide6.QtCore import QObject, Signal, Slot, Property

class ScreenLoader(QObject):
    """A small Python-side screen navigation manager exposed to QML.

    Purpose:
    - Centralize navigation requests from Python or QML.
    - Maintain a simple history stack and expose back/canGoBack.
    - Emit a signal when navigation should occur; QML can listen and
      run its existing transition animation when receiving the signal.

    Contract (2-4 bullets):
    - Inputs: navigateTo(screen: str), back(), clearHistory()
    - Outputs: emits `navigationRequested(screen)` when a navigation is requested
    - Properties: currentScreen (str), canGoBack (bool)
    - Error modes: invalid/empty screen string is ignored
    """

    navigationRequested = Signal(str)
    currentScreenChanged = Signal()
    historyChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._current = ""
        self._history = []

    # currentScreen (read-only)
    def getCurrentScreen(self):
        return self._current

    currentScreen = Property(str, getCurrentScreen, notify=currentScreenChanged)

    # canGoBack (derived)
    def getCanGoBack(self):
        return len(self._history) > 0

    canGoBack = Property(bool, getCanGoBack, notify=historyChanged)

    @Slot(str)
    def navigateTo(self, qmlSource: str):
        """Request navigation to a new QML source.

        Emits `navigationRequested` with the requested source. The QML side
        should perform the actual Loader swapping/animation and may call back
        into this object to update `currentScreen` if desired.
        """
        try:
            if not qmlSource:
                return
            # normalize to string
            qmlSource = str(qmlSource)
        except Exception:
            return

        if qmlSource == self._current:
            return

        # push current into history if present
        if self._current:
            self._history.append(self._current)
            self.historyChanged.emit()

        # update current and notify
        self._current = qmlSource
        self.currentScreenChanged.emit()

        # tell QML to actually perform the page transition
        self.navigationRequested.emit(qmlSource)

    @Slot()
    def back(self):
        """Navigate back to the previous screen if available."""
        if not self._history:
            return
        last = self._history.pop()
        self._current = last
        self.historyChanged.emit()
        self.currentScreenChanged.emit()
        self.navigationRequested.emit(last)

    @Slot()
    def clearHistory(self):
        self._history = []
        self.historyChanged.emit()

    @Slot(result=str)
    def peekCurrent(self):
        return self._current

