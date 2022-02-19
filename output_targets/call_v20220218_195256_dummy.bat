cd C:\Users\sweisberg\documents\usrep_reeds\usrep-reeds-dummy\runs\v20220218_195256_dummy

call gams CreateModel.gms pysetup=0 gdxcompress=1 xs=g00files\v20220218_195256_dummy o=lstfiles\1_Inputs.lst --basedir=C:\Users\sweisberg\documents\usrep_reeds\usrep-reeds-dummy\ --casedir=C:\Users\sweisberg\documents\usrep_reeds\usrep-reeds-dummy\runs\v20220218_195256_dummy\ logFile=gamslog.txt appendLog=1 > test.txt 2> teste.txt

call run.bat bau RefRen 2006 2050 0 0 RefRen v20220218_195256_dummy