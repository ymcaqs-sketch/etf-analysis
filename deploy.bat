@echo off
chcp 65001 >nul
echo.
echo ┌─────────────────────────────────────────────┐
echo │   dev/index.html → index.html 배포          │
echo │   https://ymcaqs-sketch.github.io/etf-analysis/ │
echo └─────────────────────────────────────────────┘
echo.

cd /d "%~dp0"

:: 현재 브랜치 확인
for /f "tokens=*" %%b in ('git rev-parse --abbrev-ref HEAD') do set BRANCH=%%b
if not "%BRANCH%"=="dev" (
    echo [오류] dev 브랜치에서만 실행 가능합니다. 현재: %BRANCH%
    pause & exit /b 1
)

:: 미커밋 변경사항 확인
git diff --quiet && git diff --cached --quiet
if errorlevel 1 (
    echo [오류] 커밋되지 않은 변경사항이 있습니다. 먼저 dev에 커밋하세요.
    git status --short
    pause & exit /b 1
)

:: dev/index.html → index.html 복사
echo [1/4] dev/index.html → index.html 복사 중...
copy /y dev\index.html index.html >nul
echo       완료

:: prod 커밋 (dev 브랜치에서)
echo [2/4] prod 파일 커밋...
git add index.html
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "deploy: promote dev to prod"
    git push origin dev
)

:: main에 머지
echo [3/4] main 브랜치 머지...
git checkout main
git merge dev --no-edit
git push origin main

:: dev로 복귀
echo [4/4] dev 브랜치 복귀...
git checkout dev

echo.
echo ✅ 배포 완료!
echo    DEV  → https://ymcaqs-sketch.github.io/etf-analysis/dev/
echo    PROD → https://ymcaqs-sketch.github.io/etf-analysis/
echo    (GitHub Pages 반영까지 1~2분 소요)
echo.
pause
