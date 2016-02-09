import sys
import math
import time
import pickle
import numpy as np

from functools import partial

from sklearn import preprocessing
from sklearn import svm

from multiprocessing import Pool


def func(data, model):
		return model.predict(data)

if __name__ == "__main__":

	start_time = time.time()

	print "loading model..."

	local_path = '/Users/juansaldarriaga/Google_Drive/02_Freelancing/02_Projects/1505_Taxi_Predictions/07_Model/160207_Test_Model/'

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

	num_cores = 8

	chunks = num_cores
	list_of_data = np.split(D_scaled, [math.floor(D_scaled.shape[0] / float(chunks)) * (x+1) for x in range(chunks-1)])

	start_time = time.time()

	pool = Pool(processes=num_cores)
	partial_func = partial(func, model = dataModel)
	prediction = pool.map(partial_func, list_of_data)

	pool.close()
	pool.join()

	print "prediction finished [" + str(int(time.time() - start_time)) + " sec]"


	prediction_joined = np.hstack(tuple(prediction))

	# print prediction
	print "min: " + str(np.amin(prediction_joined))
	print "max: " + str(np.amax(prediction_joined))