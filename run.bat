@echo off
echo ファイル生成を開始します。
powershell -NoProfile -ExecutionPolicy Unrestricted .\make.ps1
echo 完了しました！
pause > nul
exit
