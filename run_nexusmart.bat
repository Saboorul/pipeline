@echo off
cd /d "%~dp0"
title NexusMart Server Launcher
echo ===================================================
echo           NexusMart Local Server Launcher
echo ===================================================
echo.

:: Check for virtual environment
if not exist "venv\Scripts\python.exe" (
    echo [ERROR] Virtual environment 'venv' not found or incomplete.
    echo Please create it first: python -m venv venv
    pause
    exit /b 1
)

echo [1/4] Activating Python Virtual Environment...
call venv\Scripts\activate.bat
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment.
    pause
    exit /b 1
)

echo [2/4] Applying Database Migrations...
venv\Scripts\python.exe manage.py migrate
if errorlevel 1 (
    echo [ERROR] Migrations failed.
    pause
    exit /b 1
)

echo [3/4] Initializing Product and Category Images...
venv\Scripts\python.exe -c "import os, shutil; mr = r'media'; si = r'static\images\items'; os.makedirs(os.path.join(mr, 'photos', 'categories'), exist_ok=True); os.makedirs(os.path.join(mr, 'photos', 'category'), exist_ok=True); pm = {'ATX-Jeans_HYTQBa5.jpg': '1.jpg', 'jordan-true-flight-basketball-shoes.jpg': '2.jpg', 'Blue-Shirt.jpg': '3.jpg', 'US-Polo-Assn_Jacket.jpg': '4.jpg', 'Wrangler-Shirt.jpg': '5.jpg', 'Mavi_jeans.jpg': '6.jpg', 'image13.jpg': '7.jpg'}; [shutil.copy(os.path.join(si, s), os.path.join(mr, 'photos', 'categories', d)) for d, s in pm.items() if os.path.exists(os.path.join(si, s)) and not os.path.exists(os.path.join(mr, 'photos', 'categories', d))]; cm = {'tshirts_DzeqLYx.jpg': '8.jpg', 'shirts_qqbmQtD.jpg': '9.jpg', 'jeans_iJaiaNx.jpg': '10.jpg', 'jackets_Ws6rBBe.jpg': '11.jpg', 'shoes_nUU4kRd.png': '12.jpg', 'ATX-Jeans.jpg': '1.jpg'}; [shutil.copy(os.path.join(si, s), os.path.join(mr, 'photos', 'category', d)) for d, s in cm.items() if os.path.exists(os.path.join(si, s)) and not os.path.exists(os.path.join(mr, 'photos', 'category', d))]"

echo [4/4] Starting Django Development Server...
echo Visit http://127.0.0.1:8000/ in your browser.
echo.
venv\Scripts\python.exe manage.py runserver

