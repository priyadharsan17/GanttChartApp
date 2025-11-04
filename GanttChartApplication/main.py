import sys
import os

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from src.application_manager import ApplicationManager
from src.backend import Backend


def main():
	app = QGuiApplication(sys.argv)

	engine = QQmlApplicationEngine()

	app_manager = ApplicationManager()
	backend = Backend()

	# expose objects to QML
	engine.rootContext().setContextProperty("appManager", app_manager)
	engine.rootContext().setContextProperty("backend", backend)

	qml_file = os.path.join(os.path.dirname(__file__), "qml", "App.qml")
	engine.load(qml_file)

	if not engine.rootObjects():
		return -1

	return app.exec()


if __name__ == "__main__":
	sys.exit(main())
