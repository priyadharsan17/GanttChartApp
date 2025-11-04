@echo off
REM Creates a virtual environment in .venv and installs dependencies from requirements.txt
REM Usage: open cmd.exe in d:\Projects\GanttChartApplication and run create_venv.bat

python -m venv .venv
if errorlevel 1 (
  echo Failed to create virtual environment. Ensure Python is on PATH.
  exit /b 1
)
call .venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt
echo Done.
pause
echo    pip install -r requirements.txt

REM Try to run installation automatically:
call .venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt

echo Done.
pause
