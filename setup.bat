@echo off
REM Setup script for Job Portal Django application

echo ========================================
echo Job Portal Setup Script
echo ========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Python is not installed or not in PATH
    pause
    exit /b 1
)

echo [1/5] Python version check passed
echo.

REM Check if virtual environment exists
if not exist "venv" (
    echo [2/5] Creating virtual environment...
    python -m venv venv
    call venv\Scripts\activate.bat
) else (
    echo [2/5] Virtual environment already exists, activating...
    call venv\Scripts\activate.bat
)
echo.

REM Install dependencies
echo [3/5] Installing dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt
echo.

REM Run migrations
echo [4/5] Running database migrations...
python manage.py migrate
echo.

REM Create superuser
echo [5/5] Creating superuser account...
python manage.py createsuperuser
echo.

echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo To run the development server:
echo   python manage.py runserver
echo.
echo To run tests:
echo   python manage.py test
echo.
echo To collect static files:
echo   python manage.py collectstatic --noinput
echo.
pause
