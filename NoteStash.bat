
::##################################################
::# Script  : NoteStash
::# Author  : Noel Williams
::# Updated : 22/12/23   
::# Input   : Notes
::# Output  : txt files to store and search notes
::################################################## 


@echo off

:menu
cls
echo What do you want to do?
echo 1. Create a new file
echo 2. Search for files with your name in the filename
set /p choice="Enter your choice: "

if %choice%==1 goto create_file
if %choice%==2 goto search_files
goto menu

:create_file
set /p company="Enter the client name: "
set /p name="Enter users name: "
set /p contact="Enter users contact: "
set /p title="Enter the title of the issue: "
set /p issue="Enter the issue: "

REM Get the current date
for /f "tokens=1-3 delims=/" %%a in ("%date%") do (
set day=%%a
set month=%%b
set year=%%c
)

REM Create the folders if they don't exist
if not exist "%year%" mkdir "%year%"
if not exist "%year%\%month%" mkdir "%year%\%month%"
if not exist "%year%\%month%\%day%" mkdir "%year%\%month%\%day%"

REM Create the filename and save the data to the file
set filename="%year%\%month%\%day%\%company%-%name%-%title%.txt"
type nul > %filename%
echo Client: %company%>>%filename%
echo. >>%filename%
echo Name: %name%>>%filename%
echo Contact: %contact%>>%filename%
echo. >>%filename%
echo Title: %title%>>%filename%
echo. >> %filename%
echo Issue: >>%filename%
echo. >> %filename%
echo %issue%>>%filename%

echo Data saved to %filename%

start "" "%SystemRoot%\Notepad.exe" %filename%

set company=""
set name=""
set contact=""
set title=""
set issue=""

goto menu

:search_files
setlocal EnableDelayedExpansion

set /p name="Enter search query (name, org, title): "

set counter=0


REM Search for text files containing name in filename
for /r %%f in ("*%name%*.txt") do (
set filename=%%f
set /a counter+=1

@echo off

rem Get input path from the user

rem Replace "/2023/" with a unique delimiter
set "tempPath=!filename:NoteStash=###!"


rem Split the path by the unique delimiter
for /f "tokens=2 delims=###" %%a in ("!tempPath!") do set "result=%%a"

rem Trim leading spaces
set "result=!result:~1!"

for /f "tokens=1,2,3,* delims=\" %%A in ("!result!") Do (
	
	set year=%%A
	set month=%%B
	set date=%%C
	set file=%%D
	@echo !counter!.!date!-!month!-!year!		!file:.txt=!
)

set "file[!counter!]=%%f"
)

REM Check if any files were found
if %counter%==0 (
echo No files found with name "%name%" in filename.
pause
goto :search_files_end
)


REM Prompt user to select a file to open
set /p selection="Enter the number of the file you want to open: "

REM Check if selection is valid
if %selection% leq 0 goto invalid_selection
if %selection% gtr %counter% goto invalid_selection

REM Open selected file in Notepad
start "" "%SystemRoot%\Notepad.exe" "!file[%selection%]!" 

goto search_files_end

:invalid_selection
echo Invalid selection.

set /p rerun="Do you want to search for files again? (y/n): "
if /i "%rerun%"=="y" goto search_files

:search_files_end
goto menu

:end
