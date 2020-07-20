import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), os.pardir)))

import CFML_api
import numpy as np 

cellv = np.asarray([5,5,8], dtype='float32')
angl = np.asarray([90,90,80], dtype='float32')

a=CFML_api.Cell(cellv, angl)

print("======")
a.print_description()
print("======")
print(a.lattangle)

a.lattangle = np.asarray([90,90,90], dtype="float32")
print("======")
print(a.lattangle)