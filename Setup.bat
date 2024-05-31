@echo off
setlocal

rem GitHub username and repository
set "githubUser=RandomBroLol"
set "githubRepo=BAT"

rem URL of the GitHub file to download
set "githubUrl=https://github.com/%githubUser%/%githubRepo%/raw/main/Function.exe"

rem File name to save the downloaded file
set "fileName=Function.exe"

rem Get the full path of the directory where this script is located
for %%I in ("%~dp0.") do set "scriptDir=%%~fI"

rem Path to the local file
set "localFile=%scriptDir%\%fileName%"

rem Download the file from GitHub
powershell -command "(New-Object Net.WebClient).DownloadFile('%githubUrl%', '%localFile%')"

rem Check for updates
if exist "%localFile%" (
    for /f %%A in ('powershell -command "(Invoke-WebRequest -Uri '%githubUrl%' -Method Head).Headers.LastModified"') do set "githubDate=%%A"
    for %%F in ("%localFile%") do set "localDate=%%~tF"
    
    rem Compare last modified dates
    if "%githubDate%" neq "%localDate%" (
        echo Update detected. Updating %fileName%...
        del "%localFile%" >nul 2>&1
        powershell -command "(New-Object Net.WebClient).DownloadFile('%githubUrl%', '%localFile%')"
        echo %fileName% updated successfully.
    ) else (
        echo %fileName% is up to date.
    )
) else (
    echo Failed to download %fileName% from GitHub.
)

echo Press any key to exit...
pause >nul

endlocal