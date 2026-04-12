@echo off
chcp 65001 >nul
echo.
echo ┌─────────────────────────────────────┐
echo │   로컬 개발 서버 시작               │
echo │   http://localhost:8080             │
echo └─────────────────────────────────────┘
echo.
echo 종료: Ctrl+C
echo.
cd /d "%~dp0"
python -m http.server 8080
