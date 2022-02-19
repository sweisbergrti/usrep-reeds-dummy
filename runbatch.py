import os
import sys
import pandas as pd
import numpy as np
import time
import csv
import shutil


original_stdout = sys.stdout
sys.stdout = open("PYTHON_log.txt","w")

print("Successfully imported python packages in runbatch.py")
test = np.zeros(5)
print(test)
print("Successfully used imported python packages in runbatch.py")

sys.path.insert(0, 'input_processing') # add the dir to the path for importing modules

# pointer to gams--change this
GAMSDir = r"C:\\GAMS\\win64\\30.3" 
InputDir = os.getcwd()

sys.stdout = original_stdout

# Python will need to take input directly from the user to define some key parameters
print("-- Specify the batch name --")
print("-- A value of 0 will assign the date and time as the batch name")

BatchName = str(input('Batch Name: '))

if BatchName == '0':
    BatchName = 'v' + time.strftime("%Y%m%d_%H%M%S")

lstfile = BatchName + '_dummy'

print("\n\nSpecify the suffix for the cases_suffix.csv file")
print("A blank input will default to the cases.csv file\n")    

cases_suffix = str(input('Case Suffix: '))

# most other parameters will come from this cases file
# for our purposes, it's always going to read in the same file
if cases_suffix == '':
    df_cases = pd.read_csv('cases.csv',dtype = object, index_col = 0)
else:
    df_cases = pd.read_csv('cases.csv',dtype = object, index_col = 0)


# a few more input variables -- right now I'm not dealing with multithreading -- I'll come back and add this
WORKERS = int(input('Number of simultaneous runs [integer]: '))
print("")
WORKERS = 1

ruiter = int(input('How many iterations between REEDS and USREP [integer]: '))
print("")

sys.stdout = open("PYTHON_log.txt","a")

print("Successfully received user input in runbatch.py")

casedir = os.path.join(InputDir,"runs\\",lstfile)
caseinputs = os.path.join(casedir,"inputs_case")

# make some folders for the individual model run
if not os.path.exists("runs"): os.mkdir("runs")
if not os.path.exists("runs\\" + lstfile): os.mkdir("runs\\" + lstfile)
if not os.path.exists("runs\\" + lstfile + "\\g00files"): os.mkdir("runs\\" + lstfile + "\\g00files")
if not os.path.exists("runs\\" + lstfile + "\\lstfiles"): os.mkdir("runs\\" + lstfile + "\\lstfiles")
if not os.path.exists("runs\\" + lstfile + "\\outputs"): os.mkdir("runs\\" + lstfile + "\\outputs")
if not os.path.exists("runs\\" + lstfile + "\\inputs_case"): os.mkdir("runs\\" + lstfile + "\\inputs_case")
if not os.path.exists("runs\\" + lstfile + "\\outputs\\variabilityFiles"): os.mkdir("runs\\" + lstfile + "\\outputs\\variabilityFiles")
if not os.path.exists(caseinputs): os.mkdir(caseinputs)

# test calling another python file
import calc_financial_inputs as cFuncs
cFuncs.calc_financial_inputs(lstfile)

print("Successfully called calc_financial_inputs.py from runbatch.py")

OutputDir = os.path.join(InputDir,"runs\\" + lstfile)

# more folders
if not os.path.exists("runs\\" + lstfile + "\\link"): os.mkdir("runs\\" + lstfile + "\\link")
if not os.path.exists("runs\\" + lstfile + "\\link\\reeds_out"): os.mkdir("runs\\" + lstfile + "\\link\\reeds_out")
if not os.path.exists("runs\\" + lstfile + "\\link\\usrep_out"): os.mkdir("runs\\" + lstfile + "\\link\\usrep_out")
if not os.path.exists("runs\\" + lstfile + "\\usrep"): os.mkdir("runs\\" + lstfile + "\\usrep")
if not os.path.exists("runs\\" + lstfile + "\\usrep\\restart"): os.mkdir("runs\\" + lstfile + "\\usrep\\restart")
if not os.path.exists("runs\\" + lstfile + "\\usrep\\results"): os.mkdir("runs\\" + lstfile + "\\usrep\\results")
if not os.path.exists("runs\\" + lstfile + "\\usrep\\core"): os.mkdir("runs\\" + lstfile + "\\usrep\\core")
if not os.path.exists("runs\\" + lstfile + "\\usrep\\gdx"): os.mkdir("runs\\" + lstfile + "\\usrep\\gdx")
if not os.path.exists("runs\\" + lstfile + "\\usrep\\lst"): os.mkdir("runs\\" + lstfile + "\\usrep\\lst")

# copy a bunch of files into the run folder
with open('FilesForBatch.csv', 'r') as f:
    reader = csv.reader(f, delimiter = ',')
    for row in reader:
        filename = row[0]
        if filename[:6]=='inputs':
            dir_dst = caseinputs
        else:
            dir_dst = casedir
        src_file = os.path.join(InputDir, filename)
        if os.path.exists(src_file):
            shutil.copy(src_file, dir_dst)

print("Successfully copied some files into the runs/ directory")

usrep_dir = os.path.join(os.getcwd(),"usrep")
if os.path.exists(os.path.join(casedir,"usrep")) == True:
    shutil.rmtree(os.path.join(casedir,"usrep"))
shutil.copytree(os.path.join(usrep_dir), os.path.join(casedir,"usrep"))


# let's try writing to a .bat file
with open(os.path.join(OutputDir,'call_' + lstfile + '.bat'), 'w') as OPATH:
    OPATH.writelines("cd " + casedir + "\n" + "\n")
    OPATH.writelines("call gams CreateModel.gms pysetup=0 gdxcompress=1 xs=g00files\\" + lstfile + " o=lstfiles\\1_Inputs.lst --basedir=" + InputDir + "\\ --casedir=" + InputDir + "\\runs\\" + lstfile + "\\ logFile=gamslog.txt appendLog=1" + "\n" + "\n")
    OPATH.writelines("call run.bat bau RefRen 2006 2050 0 " + str(ruiter) + " RefRen " + lstfile)

OPATH.close()

print("Successfully wrote some lines to a .bat file from runbatch.py")

# let's try calling the .bat file now!
os.system('start /wait cmd /c ' + os.path.join(OutputDir, 'call_' + lstfile + '.bat'))

print("Successfully called the batchfile from runbatch.py. I think that means we're done with the Python stuff!")

sys.stdout.close()

shutil.copy("PYTHON_log.txt",casedir)
os.remove("PYTHON_log.txt")


