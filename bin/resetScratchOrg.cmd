@ECHO OFF
@REM ###############################################################
@REM #
@REM #  bin\resetScratchOrg.cmd [org_alias]
@REM #
@REM ###############################################################

REM set variables
SET "org_alias=%~1"
ECHO org_alias is %org_alias%
SET "temp_dir=temp"

ECHO.
ECHO Setting up scratch org %org_alias%

ECHO.
REM Delete any previous scratch org with same alias
ECHO Delete any previous scratch org with same alias
ECHO sf org delete scratch --no-prompt --target-org %org_alias%
CALL sf org delete scratch --no-prompt --target-org %org_alias%

ECHO.
REM Create new scratch org
ECHO Create new scratch org
ECHO sf org create scratch --wait 30 --duration-days 2 --definition-file config/project-scratch-def.json --alias %org_alias%
CALL sf org create scratch --wait 30 --duration-days 2 --definition-file config/project-scratch-def.json --alias %org_alias%
ECHO Setting %org_alias% as the default username
CALL sf config set target-org %org_alias%
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
REM Change default timezone of org
ECHO Change default timezone of org
ECHO sf data update record --sobject Organization --where "Name='SED23-fundamentals-enterprise-patterns'" --values "TimeZoneSidKey='America/New_York'" --target-org %org_alias%
CALL sf data update record --sobject Organization --where "Name='SED23-fundamentals-enterprise-patterns'" --values "TimeZoneSidKey='America/New_York'" --target-org %org_alias%
ECHO.
REM Change timezone of default DX Scratch Org User
ECHO Change timezone of default DX Scratch Org User
ECHO sf data update record --sobject User --where "Name='User User'" --values "TimeZoneSidKey='America/New_York'" --target-org %org_alias%
CALL sf data update record --sobject User --where "Name='User User'" --values "TimeZoneSidKey='America/New_York'" --target-org %org_alias%

ECHO.
REM Installing all framework dependencies
ECHO Installing all framework dependencies
REM     Installing fflib-apex-mocks framework
ECHO     Installing fflib-apex-mocks framework
RMDIR "%temp_dir%\fflib-apex-mocks" /S /Q
ECHO git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-mocks.git %temp_dir%\fflib-apex-mocks
CALL git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-mocks.git %temp_dir%\fflib-apex-mocks
if %errorlevel% neq 0 exit /b %errorlevel%
cd %temp_dir%\fflib-apex-mocks
ECHO sf project deploy start --ignore-conflicts --target-org %org_alias%
CALL sf project deploy start --ignore-conflicts --target-org %org_alias%
if %errorlevel% neq 0 exit /b %errorlevel%
cd ../..

ECHO.
REM     Installing fflib-apex-common framework
ECHO     Installing fflib-apex-common framework
RMDIR "%temp_dir%\fflib-apex-common" /S /Q
ECHO git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-common.git %temp_dir%\fflib-apex-common
CALL git clone -q --no-tags https://github.com/apex-enterprise-patterns/fflib-apex-common.git %temp_dir%\fflib-apex-common
if %errorlevel% neq 0 exit /b %errorlevel%
cd %temp_dir%\fflib-apex-common
ECHO sf project deploy start --ignore-conflicts --target-org %org_alias%
CALL sf project deploy start --ignore-conflicts --target-org %org_alias%
if %errorlevel% neq 0 exit /b %errorlevel%
cd ../..

ECHO.
REM Pushing project source code to org
ECHO Pushing project source code to org
ECHO sf project deploy start --ignore-conflicts --target-org %org_alias%
CALL sf project deploy start --ignore-conflicts --target-org %org_alias%
if %errorlevel% neq 0 exit /b %errorlevel%

ECHO.
REM Opening the org
ECHO Opening the org
ECHO sf org open --path lightning/setup/SetupOneHome/home --target-org %org_alias%
CALL sf org open --path lightning/setup/SetupOneHome/home --target-org %org_alias%
ECHO.
ECHO Scratch org %org_alias% is ready
ECHO.
