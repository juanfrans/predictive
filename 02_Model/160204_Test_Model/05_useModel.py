
import time
import pickle
import numpy as np

from sklearn import preprocessing
from sklearn import svm

start_time = time.time()

print "loading model..."

local_path = '/Users/juansaldarriaga/Google_Drive/02_Freelancing/02_Projects/1505_Taxi_Predictions/07_Model/160204_Test_Model/'

with open(local_path + 'dataModel.pkl', 'rb') as f:
	dataModel = pickle.load(f)

with open(local_path + 'scaler.pkl', 'rb') as f:
	scaler = pickle.load(f)

print "model loaded [" + str(int(time.time() - start_time)) + " sec]"

latRange = [40.758160, 40.761869] # array of latitude values
lngRange = [-73.976134, -73.968107] # array of longitude values

data = []

doy = 1 # January 1st
dow = 1 # Monday
tod = 1 # 6am - noon
temp = 60 # 60 deg F
condition = 0 # clear
steps = 50

for lat in np.linspace(latRange[0], latRange[1], steps): # Creating an array of lats from start to finish with 100 steps
	for lng in np.linspace(lngRange[0], lngRange[1], steps): # Creating an array of longs from start to finish with 100 steps
		data.append([doy, dow, tod, lat, lng, temp, condition]) # Creating the final array with lat, long, days and condition

D = np.asarray(data, dtype='float') # Converts input into array with a specific data type (in this case, floats)
print D.shape # Prints number of arrays and number of items in each array

D_scaled = scaler.transform(D) # Scales the array to fit the model

start_time = time.time()

prediction = dataModel.predict(D_scaled) # Scales back to original

print "prediction finished [" + str(int(time.time() - start_time)) + " sec]"

print prediction
print "min: " + str(np.amin(prediction))
print "max: " + str(np.amax(prediction))