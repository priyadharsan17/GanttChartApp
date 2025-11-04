# GanttChartApplication (PySide6 + QML)

This small scaffold demonstrates a PySide6 application with a QML frontend and a Python backend.

Features added:
- `src/application_manager.py`: manages theme, fonts, and resolution dynamically and is exposed to QML as `appManager`.
- `src/backend.py`: backend stub exposing a `login(username, password)` slot and emitting `loginResult(success, message)`.
- `qml/App.qml` and `qml/Login.qml`: a modern login screen bound to `appManager` properties.

Quick start (Windows PowerShell):

1. Create and activate a virtualenv (optional but recommended):

```powershell
py -3 -m venv .venv; .\.venv\Scripts\Activate.ps1
```

2. Install deps:

```powershell
pip install -r requirements.txt
```

3. Run the app:

```powershell
py main.py
```

Default test credentials: username `user`, password `pass`.

Notes:
- This is a small scaffold for demonstration. Extend `ApplicationManager` to add persistence, color palettes, and font loading as needed.
