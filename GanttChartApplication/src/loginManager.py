from PySide6.QtCore import QObject, Signal, Slot


class LoginManager(QObject):
    # Emits (success: bool, message: str)
    loginResult = Signal(bool, str)
    logoutRequested = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)

    @Slot(str, str)
    def login(self, username, password):
        # TODO: replace with real authentication
        if username == "user" and password == "pass":
            self.loginResult.emit(True, f"Welcome, {username}")
        else:
            self.loginResult.emit(False, "Invalid username or password")

    @Slot()
    def logout(self):
        self.logoutRequested.emit()
