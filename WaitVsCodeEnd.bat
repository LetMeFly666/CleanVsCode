@echo off
set waitingTaskName="Code.exe"
:begin
for /f "delims= " %%i in ('tasklist') do (
    if "%%i" == %waitingTaskName% (
        echo %waitingTaskName% is running, sleep 5s.
        timeout /T 5 /NOBREAK
        goto begin
    )
)

:taskIsEnd
    echo task %waitingTaskName% isn't running.
    call CleanVsCode.bat
:batEnd