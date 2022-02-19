import gdxpds
import pandas as pd
import os
import argparse

print("Testing reading data from GDX in Python")
print(os.getcwd())

parser = argparse.ArgumentParser(description="""This file bins prescribed wind by TRG""")
parser.add_argument('reeds_dir', help = "Reeds directory")
parser.add_argument('test', help = 'test')
parser.add_argument('existing', help = 'gdx test file')
parser.add_argument('output', help = 'output directory')

args = parser.parse_args()
existing_capacity_file = args.existing
existing_capacity = gdxpds.to_dataframes(os.path.join('..\\..\\inputs','capacitydata',existing_capacity_file))

outdir = args.output
print("----------------------------------")
print(existing_capacity['tmpCSPOct'])
print("-----------------------------------")
print(existing_capacity['tmpDUPVOn'])
print("----------------------------------------------")
existing_capacity = pd.DataFrame(existing_capacity['tmpDUPVOn'])
print(existing_capacity)
existing_capacity.to_csv(os.path.join(outdir,'exog_wind_by_trg.csv'), index = False)

print("Successfully read data from GDX into csv in Python")