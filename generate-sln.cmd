@echo off
for %%I in (.) do set CurrDirName=%%~nxI

echo.
echo Generating %CurrentDirName%.sln
echo.

dotnet new sln -n %CurrDirName% --force

for /f %%a in ('dir /b /s .\*.??proj') do @dotnet sln add %%a

echo.
echo Created %CurrDirName%.sln!
echo.