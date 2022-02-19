:@echo off

set udir=usrep\

del GAMS_log.txt

set usrepdata=EPA_r30
set startyr_USREP=2006
set startyr_ReEDS=2010
set tint=5


:: working directory
for %%* in (.) do set wd=%%~n*

:: input processing
:: bau
set tag=%1
:: refren
set case=%2
:: 2006
set curyr=%3
:: 2040
set endyr=%4
:: 0
set it=%5
:: maximum iterations - from runbatch.py
set maxitr=%6
:: bau case
set bau=%7

set gamslogopt=ps=0 logOption=4 logFile=gamsGAMS_log.txt appendLog=1

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::  REEDS (pretend) ::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:ReEDS

if %curyr% lss %startyr_ReEDS% goto USREP
set /a nextyr=%curyr%+%tint%

echo ReEDS %case% curyr=%curyr% it=%it% >> GAMS_log.txt

:: call a gams file
call gams .\d_solvereeds.gms o=lstfiles\reeds_%curyr%_%it%.lst


if %it% lss %maxitr% goto endR
if %nextyr% gtr 2050 goto endR

:: maybe call a python file


:endR


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::      USREP (pretend)   :::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:USREP

echo USREP %case% curyr=%curyr% it=%it% >> GAMS_log.txt
echo .>> GAMS_log.txt

:: call a second gams file
call gams .\usrep\core\solve_usrep.gms o=usrep\lst\usrep_%curyr%_%it%.lst license=gamslice.txt


:endU



::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::: COUNTER :::::::::::::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:nextitr
set /a it0=%it%
set /a it+=1

if %curyr% lss %startyr_ReEDS% goto resetit
if %it% leq %maxitr% goto ReEDS

:resetit
set it=0

:nextyear
set /a curyr+=%tint%
if %curyr% equ 2011 set curyr=2010
if %curyr% leq %endyr% goto ReEDS

goto report


:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::     REPORT    :::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:report

echo writing report in GDX format >> GAMS_log.txt

call gams .\e_report.gms o=lstfiles\report.lst

echo writing dumping report to csv >> GAMS_log.txt

call gams .\e_report_dump.gms o=lstfiles\report_dump.lst

echo Successfully ran model iterations and wrote reports. That's it! That's the end. Good job. >> GAMS_log.txt

:end