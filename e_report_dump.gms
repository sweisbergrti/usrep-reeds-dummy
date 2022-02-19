$title report dump

$setglobal ds \

$ifthen.unix %system.filesys% == UNIX
$setglobal ds /
$endif.unix

$setglobal outputsPath 'outputs%ds%'

$call 'gdxdump outputs%ds%report.gdx format=csv symb=usage > %outputsPath%report.csv'