print("Successfully called calc_financial_inputs.py from runbatch.py")

import os
import pandas as pd
import support_functions as sFuncs
import csv

def calc_financial_inputs(lstfile):
    input_dir = os.path.join('inputs')
    output_dir = os.path.join('runs',lstfile,'inputs_case')

    # read some input
    test_df = pd.read_csv(os.path.join(input_dir,'test_inputs1.csv'))

    # process that input
    test_df = test_df.loc[test_df['columna'] != 'banana']

    # create some output
    test_df.to_csv(os.path.join(output_dir,'test_outputs1.csv'), index = False)

    print("Successfully did some data processing in calc_financial_inputs.csv")

    # test the connection to another python file
    sFuncs.test_function