@echo off
chcp 65001 >nul
echo.
echo ┌──────────────────────────────────────────────┐
echo │   로컬 개발 서버                             │
echo │   DEV  → http://localhost:8080/dev/          │
echo │   PROD → http://localhost:8080/              │
echo └──────────────────────────────────────────────┘
echo.
echo 종료: Ctrl+C
echo.
cd /d "%~dp0"
start http://localhost:8080/dev/
python -m http.server 8080
