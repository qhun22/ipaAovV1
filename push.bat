@echo off
setlocal

echo Pushing to GitHub...
git add .
git commit -m "Update Camera Research iOS project"
if errorlevel 1 (
    echo No new changes to commit, or commit failed.
    exit /b 1
)
git push origin main
if errorlevel 1 (
    echo Push failed.
    exit /b 1
)
echo Push completed.
endlocal
