from PySide6.QtCore import QObject, Signal, Property


class ApplicationManager(QObject):
    themeChanged = Signal()
    fontChanged = Signal()
    resolutionChanged = Signal()
    scaleChanged = Signal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self._theme = "light"
        # use simple color strings for QML bindings
        self._primary_color = "#1976D2"  # blue
        self._font_family = "Segoe UI"
        self._base_font_size = 14
        self._width = 900
        self._height = 600
        self._ui_scale = 1.0

    # Theme
    def getTheme(self):
        return self._theme

    def setTheme(self, value):
        if value == self._theme:
            return
        self._theme = value
        # simple theme mapping; extendable
        if value == "dark":
            self._primary_color = "#1E1E1E"
        else:
            self._primary_color = "#F6F7F9"
        self.themeChanged.emit()

    theme = Property(str, getTheme, setTheme, notify=themeChanged)

    # Primary color (derived from theme or explicitly set)
    def getPrimaryColor(self):
        return self._primary_color

    def setPrimaryColor(self, value):
        if value == self._primary_color:
            return
        self._primary_color = value
        self.themeChanged.emit()

    primaryColor = Property(str, getPrimaryColor, setPrimaryColor, notify=themeChanged)

    # Font
    def getFontFamily(self):
        return self._font_family

    def setFontFamily(self, value):
        if value == self._font_family:
            return
        self._font_family = value
        self.fontChanged.emit()

    fontFamily = Property(str, getFontFamily, setFontFamily, notify=fontChanged)

    def getBaseFontSize(self):
        return self._base_font_size

    def setBaseFontSize(self, value):
        if value == self._base_font_size:
            return
        self._base_font_size = int(value)
        self.fontChanged.emit()

    baseFontSize = Property(int, getBaseFontSize, setBaseFontSize, notify=fontChanged)

    # Resolution
    def getWidth(self):
        return self._width

    def setWidth(self, value):
        if int(value) == self._width:
            return
        self._width = int(value)
        self.resolutionChanged.emit()

    width = Property(int, getWidth, setWidth, notify=resolutionChanged)

    def getHeight(self):
        return self._height

    def setHeight(self, value):
        if int(value) == self._height:
            return
        self._height = int(value)
        self.resolutionChanged.emit()

    height = Property(int, getHeight, setHeight, notify=resolutionChanged)

    # UI scale (float) — set from QML to inform components of current scale
    def getUiScale(self):
        return self._ui_scale

    def setUiScale(self, value):
        try:
            v = float(value)
        except Exception:
            return
        if abs(v - self._ui_scale) < 1e-6:
            return
        self._ui_scale = v
        self.scaleChanged.emit()

    uiScale = Property(float, getUiScale, setUiScale, notify=scaleChanged)
