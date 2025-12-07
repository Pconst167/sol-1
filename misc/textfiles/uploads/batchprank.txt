@ echo off
cls

echo Are you sure you want to delete all the files on drive C?
choice

if ERRORLEVEL 2 GOTO :END
if ERRORLEVEL 1 GOTO :BEGIN

:BEGIN
echo Deleting C:\My Documents\...
echo Deleting C:\Program Files\...
echo Deleting C:\WINDOWS\...
echo Cleaning up enviroment...
echo .............................
echo Your drive has successfully been wiped. (Computer will restart
echo upon keystroke.)
pause
cls
echo Just kidding...that would suck huh?
echo (c)2003 Infared Studios. All Rights reserved.


:END
echo I'm sorry, you have no choice...
GOTO :BEGIN  N  