@echo off
chcp 65001 >nul
echo.
echo ┌─────────────────────────────────────────────────┐
echo │   리얼 배포: dev → deploy 브랜치               │
echo │   https://ymcaqs-sketch.github.io/etf-analysis/ │
echo └─────────────────────────────────────────────────┘
echo.

cd /d "%~dp0"

:: dev 브랜치 확인
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

:: deploy 브랜치로 전환
echo [1/4] deploy 브랜치 전환...
git checkout deploy

:: dev/index.html → deploy 동기화 (GitHub Pages /dev/ 경로)
echo [2/4] dev/ 경로 동기화...
git checkout dev -- dev/
git add dev/index.html

:: dev/index.html → index.html (프로덕션 루트)
echo [3/4] index.html 업데이트 (프로덕션)...
copy /y dev\index.html index.html >nul
git add index.html

:: 커밋 + push
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "deploy: promote dev to prod"
) else (
    echo     변경사항 없음, 커밋 스킵
)

echo [4/4] GitHub Pages 배포 (push deploy)...
git push origin deploy

:: dev로 복귀
git checkout dev

echo.
echo 배포 완료!
echo    DEV  -^> https://ymcaqs-sketch.github.io/etf-analysis/dev/
echo    PROD -^> https://ymcaqs-sketch.github.io/etf-analysis/
echo    (GitHub Pages 반영까지 1~2분 소요)
echo.
pause
