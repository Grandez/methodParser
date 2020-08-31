: Flex
@echo off

SET OLDCD=%CD%

CD D:\cpp\parserMethod\generated
IF ERRORLEVEL  1 GOTO :ERROR
DEL /Q *.*
:..\tools\win_bison -d --no-lines -o methodParser.cpp ..\grammar\methodParser.yy
..\tools\win_bison -d -o methodParser.cpp ..\grammar\methodParser.yy
IF ERRORLEVEL  1 GOTO :ERROR 
:..\tools\flex -o methodScanner.cpp ..\grammar\methodScanner.ll
..\tools\win_flex -o methodScanner.cpp ..\grammar\methodScanner.ll
IF ERRORLEVEL  1 GOTO :ERROR 

CD %OLDCD%

:call :FileModTime test.txt A
:call :FileModTime pippo.txt B
:set "diff=0"
:if defined A if defined B set /a diff=B-A
:if %diff% gtr 2 echo xxxx
:exit /b


: :FileModTime  File  [TimeVar]
EXIT /B 0

:ERROR
CD %OLDCD%
EXIT /B 1