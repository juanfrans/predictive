
import time
import pickle
#import numpy as np

from sklearn import preprocessing
from sklearn import svm

start_time = time.time()

print "loading model..."

local_path = "C:\\Users\\danil\\Google Drive\\SYNC\\Taxi\\"

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

for lat in np.linspace(latRange[0], latRange[1], 100):
  for lng in np.linspace(lngRange[0], lngRange[1], 100):
    data.append([doy, dow, tod, lat, lng, temp, condition])

D = np.asarray(data, dtype='float')
print D.shape

D_scaled = scaler.transform(D)

start_time = time.time()

prediction = dataModel.predict(D_scaled)

print "prediction finished [" + str(int(time.time() - start_time)) + " sec]"

print prediction
print "min: " + str(np.amin(prediction))
print "max: " + str(np.amax(prediction))