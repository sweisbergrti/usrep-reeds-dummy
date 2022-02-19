$setglobal ds \

*Change the default slash if in UNIX
$ifthen.unix %system.filesys% == UNIX
$setglobal ds /
$endif.unix

*Set the end of line comment to \\
$eolcom \\

* Test R and Python calls from gams
$log
$log
$call 'Rscript %basedir%%ds%input_processing%ds%R%ds%packagesetup.R >> data_processing_log.txt 2>> data_processing_errors.txt'
$log
$log
$call 'Rscript %basedir%%ds%input_processing%ds%R%ds%fuelcostprep.R %basedir% testflag %casedir%\\inputs_case\\ >> data_processing_log.txt 2>> data_processing_errors.txt'
$log
$log
$call 'python %basedir%%ds%inputs%ds%capacitydata%ds%capacity_exog_wind.py %basedir% testflag ExistingUnits_EIA-NEMS.gdx %casedir%\\inputs_case\\ >> data_processing_log.txt 2>> data_processing_errors.txt'
