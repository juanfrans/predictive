from flask import Flask, jsonify
import sys
import math
import time
import pickle
import numpy as np
import json

from functools import partial

from sklearn import preprocessing
from sklearn import svm

from multiprocessing import Pool

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/getPrediction/<int:points>')
def getPrediction(points):
	start_time = time.time()
	modelLocation = '/Users/juansaldarriaga/Google_Drive/02_Freelancing/02_Projects/1505_Taxi_Predictions/04_Github_Repository/03_API/160207_Test_Model/'
	with open(modelLocation + 'dataModel.pkl', 'rb') as f:
		dataModel = pickle.load(f)
	with open(modelLocation + 'scaler.pkl', 'rb') as f:
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
	steps = points
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
	jsonPrediction = json.loads(json.dumps(prediction.tolist()))
	print jsonPrediction
	return jsonify({'jsonPrediction' : jsonPrediction})

@app.route('/getPrediction/parameters/<parameters>')
def getPredictionCoordinates(parameters):
	start_time = time.time()
	modelLocation = '/Users/juansaldarriaga/Google_Drive/02_Freelancing/02_Projects/1505_Taxi_Predictions/04_Github_Repository/03_API/160207_Test_Model/'
	with open(modelLocation + 'dataModel.pkl', 'rb') as f:
		dataModel = pickle.load(f)
	with open(modelLocation + 'scaler.pkl', 'rb') as f:
		scaler = pickle.load(f)
	print "model loaded [" + str(int(time.time() - start_time)) + " sec]"
	data = []
	parametersArray = parameters.split('&')
	dayOfYear = parametersArray[0].split('=')[1]
	dayOfWeek = parametersArray[1].split('=')[1]
	timeOfDay = parametersArray[2].split('=')[1]
	temperature = parametersArray[3].split('=')[1]
	weatherCondition = parametersArray[4].split('=')[1]
	coordinatePairs = parametersArray[5].split('=')[1].split(';')
	#print str(len(coordinatePairs)) + ' coordinate pairs'
	for pair in coordinatePairs:
		#print pair
		lat = pair.split(',')[0]
		lon = pair.split(',')[1]
		data.append([dayOfYear, dayOfWeek, timeOfDay, lat, lon, temperature, weatherCondition])
	#print data
	'''
	latRange = [40.758160, 40.761869] # array of latitude values
	lngRange = [-73.976134, -73.968107] # array of longitude values
	data = []
	doy = 1 # January 1st
	dow = 1 # Monday
	tod = 1 # 6am - noon
	temp = 60 # 60 deg F
	condition = 0 # clear
	steps = points
	for lat in np.linspace(latRange[0], latRange[1], steps): # Creating an array of lats from start to finish with 100 steps
		for lng in np.linspace(lngRange[0], lngRange[1], steps): # Creating an array of longs from start to finish with 100 steps
			data.append([doy, dow, tod, lat, lng, temp, condition]) # Creating the final array with lat, long, days and condition
	'''
	D = np.asarray(data, dtype='float') # Converts input into array with a specific data type (in this case, floats)
	print D.shape # Prints number of arrays and number of items in each array
	D_scaled = scaler.transform(D) # Scales the array to fit the model
	start_time = time.time()
	prediction = dataModel.predict(D_scaled) # Scales back to original
	print "prediction finished [" + str(int(time.time() - start_time)) + " sec]"
	#print prediction
	print "min: " + str(np.amin(prediction))
	print "max: " + str(np.amax(prediction))
	jsonPrediction = json.loads(json.dumps(prediction.tolist()))
	#print jsonPrediction
	return jsonify({'jsonPrediction' : jsonPrediction})
	'''
	return 'Done...'
	'''

if __name__ == '__main__':
    app.run(debug = True)