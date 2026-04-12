@echo off
chcp 65001 >nul
echo.
echo ┌─────────────────────────────────────┐
echo │   dev → main 배포                   │
echo └─────────────────────────────────────┘
echo.

cd /d "%~dp0"

:: 현재 브랜치 확인
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%b
echo 현재 브랜치: %BRANCH%

:: dev 브랜치에서만 실행 허용
if not "%BRANCH%"=="dev" (
    echo [오류] dev 브랜치에서만 배포할 수 있습니다.
    echo        현재 브랜치: %BRANCH%
    pause
    exit /b 1
)

:: 미커밋 변경사항 확인
git diff --quiet && git diff --cached --quiet
if errorlevel 1 (
    echo [오류] 커밋되지 않은 변경사항이 있습니다.
    echo        먼저 dev에 커밋한 후 배포하세요.
    git status --short
    pause
    exit /b 1
)

:: dev → main 머지 후 push
echo.
echo [1/3] main 브랜치로 전환...
git checkout main

echo [2/3] dev 머지 중...
git merge dev --no-edit

echo [3/3] GitHub Pages 배포 (push main)...
git push origin main

:: dev로 복귀
git checkout dev

echo.
echo ✅ 배포 완료 — https://ymcaqs-sketch.github.io/etf-analysis/
echo    (GitHub Pages 반영까지 1~2분 소요)
echo.
pause
