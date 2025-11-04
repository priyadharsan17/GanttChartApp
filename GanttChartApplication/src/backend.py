from PySide6.QtCore import QObject, Signal, Slot


class Backend(QObject):
    # loginResult(success, message)
    loginResult = Signal(bool, str)

    def __init__(self, parent=None):
        super().__init__(parent)

    @Slot(str, str)
    def login(self, username, password):
        # stubbed authentication; replace with real logic
        if username == "user" and password == "pass":
            self.loginResult.emit(True, "Welcome, {}".format(username))
        else:
            self.loginResult.emit(False, "Invalid username or password")
