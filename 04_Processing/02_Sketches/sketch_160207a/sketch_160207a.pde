JSONObject predictionData;
JSONArray predictionArray;
String coordinates = "";
int dayOfYear = 1;
int dayOfWeek = 2;
int timeOfDay = 1;
float temperature = 60;
int condition = 0;
float[][] positions;
float predictionValue = 0;
float maxPrediction = 0;

void setup(){
  loadFishnet();
  runModel();
  size(500,500);
  colorMode(HSB, 360, 100, 100);
  smooth();
}

void loadFishnet(){
  String basedata[] = loadStrings("Fishnet_200ft.txt");
  positions = new float[basedata.length][2];
  for (int i = 1; i < basedata.length; i++){
    float[] thisPair = new float[2];
    String thisFeature[] = split(basedata[i],',');
    thisPair[0] = float(thisFeature[1]);
    thisPair[1] = float(thisFeature[2]);
    positions[i-1] = thisPair;
    if (i == basedata.length -1){
      String thisLine[] = split(basedata[i],',');
      coordinates = coordinates + thisLine[1] + ',' + thisLine[2];
    }
    else{
      String thisLine[] = split(basedata[i],',');
      coordinates = coordinates + thisLine[1] + ',' + thisLine[2] + ';';
    }
  }
  println("Done putting together coordinates...");
  //println("Coordinates to request: " + coordinates);
}

void runModel(){
  String baseURL = "http://localhost:5000/getPrediction/parameters/";
  String parameters = "dayOfYear=" + str(dayOfYear) + "&dayOfWeek=" + str(dayOfWeek) + "&timeOfDay=" + str(timeOfDay) + "&temp=" + str(temperature) + "&condition=" + str(condition) + "&coordinates=" + coordinates;
  //println("Request = " + baseURL + parameters);
  String request = baseURL + parameters;
  println("Requesting predictions...");
  predictionData = loadJSONObject(request);
  predictionArray = predictionData.getJSONArray("jsonPrediction");
  println("Number of predictions: " + str(predictionArray.size()));
  println("Predictions:");
  //println(predictionArray);
  println("Max prediction = " + str(maxPrediction));
  maxPrediction = 0;
}

void drawButtons(){
  for (int i = 0; i < 12; i++){
    noFill();
    stroke(255);
    rect(5, 15 + 10 * i, 50, 8);
  }
  for (int i = 0; i < 4; i++){
    noFill();
    stroke(255);
    rect(65, 15 + 10 * i, 50, 8);
  }
  for (int i = 0; i < 7; i++){
    noFill();
    stroke(255);
    rect(125, 15 + 10 * i, 50, 8);
  }
  for (int i = 0; i < 10; i++){
    noFill();
    stroke(255);
    rect(185, 15 + 10 * i, 50, 8);
  }
  noStroke();
  fill(360, 0, 100);
  textSize(10);
  text("Condition", 5, 10);
  text("Hour", 65, 10);
  text("DayOfWeek", 125, 10);
  text("Temperature", 185, 10);
  text("Condition = " + str(condition), 5, 400);
  text("Hour = " + str(timeOfDay), 5, 410);
  text("Day of week = " + str(dayOfWeek), 5, 420);
  text("Temperature = " + str(temperature), 5, 430);
  text("Maximum prediction value = " + str(maxPrediction), 5, 440);
  
  fill(100, 0, 50);
  rect(5, 15 + 10 * condition, 50, 8);
  rect(65, 15 + 10 * (timeOfDay - 1), 50, 8);
  rect(125, 15 + 10 * dayOfWeek, 50, 8);
  rect(185, 15 + 10 * temperature/10, 50, 8);
}

void draw(){
  background(0);
  drawButtons();
  for (int i = 0; i < predictionArray.size(); i++){
    maxPrediction = max(maxPrediction, predictionArray.getFloat(i));
  }
  for (int i = 0; i < predictionArray.size(); i++){
    predictionValue = predictionArray.getFloat(i);
    fill(map(predictionValue, 0, 140, 200, 360), 100, 100);
    noStroke();
    float posY = map(positions[i][0], 40.79, 40.74, 0, 500);
    float posX = map(positions[i][1], -74, -73.95, 0, 500);
    //println(positions[i][0]);
    //println(str(posX) + "  " + str(posY));
    if (maxPrediction == predictionValue){
      fill(360, 0, 100);
    }
    ellipse(posX, posY, 5, 5);
  }
  fill(255);
  noStroke();
  text(str(mouseX)+','+str(mouseY),mouseX,mouseY);
}

void mousePressed(){
  if (mouseX >= 5 && mouseX <= 55 && mouseY >= 17 && mouseY <= 25){
    condition = 0;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 27 && mouseY <= 35){
    condition = 1;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 37 && mouseY <= 45){
    condition = 2;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 47 && mouseY <= 55){
    condition = 3;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 57 && mouseY <= 65){
    condition = 4;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 67 && mouseY <= 75){
    condition = 5;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 77 && mouseY <= 85){
    condition = 6;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 87 && mouseY <= 95){
    condition = 7;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 97 && mouseY <= 105){
    condition = 8;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 107 && mouseY <= 115){
    condition = 9;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 117 && mouseY <= 125){
    condition = 10;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 127 && mouseY <= 135){
    condition = 11;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 5 && mouseX <= 55 && mouseY >= 137 && mouseY <= 145){
    condition = 12;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 65 && mouseX <= 115 && mouseY >= 17 && mouseY <= 25){
    timeOfDay = 1;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 65 && mouseX <= 115 && mouseY >= 27 && mouseY <= 35){
    timeOfDay = 2;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 65 && mouseX <= 115 && mouseY >= 37 && mouseY <= 45){
    timeOfDay = 3;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 65 && mouseX <= 115 && mouseY >= 47 && mouseY <= 55){
    timeOfDay = 4;
    println("Querying model... ...");
    runModel();
  }
  if (mouseX >= 125 && mouseX <= 175 && mouseY >= 17 && mouseY <= 25){
    dayOfWeek = 0;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 27 && mouseY <= 35){
    dayOfWeek = 1;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 37 && mouseY <= 45){
    dayOfWeek = 2;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 47 && mouseY <= 55){
    dayOfWeek = 3;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 57 && mouseY <= 65){
    dayOfWeek = 4;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 67 && mouseY <= 75){
    dayOfWeek = 5;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 125 && mouseX <= 175 && mouseY >= 77 && mouseY <= 85){
    dayOfWeek = 6;
    println("Querying model... ...");
    runModel();
  }
  if (mouseX >= 185 && mouseX <= 235 && mouseY >= 17 && mouseY <= 25){
    temperature = 0;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 27 && mouseY <= 35){
    temperature = 10;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 37 && mouseY <= 45){
    temperature = 20;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 47 && mouseY <= 55){
    temperature = 30;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 57 && mouseY <= 65){
    temperature = 40;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 67 && mouseY <= 75){
    temperature = 50;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 77 && mouseY <= 85){
    temperature = 60;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 87 && mouseY <= 95){
    temperature = 70;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 97 && mouseY <= 105){
    temperature = 80;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 107 && mouseY <= 115){
    temperature = 90;
    println("Querying model... ...");
    runModel();
  }
  else if(mouseX >= 185 && mouseX <= 235 && mouseY >= 117 && mouseY <= 125){
    temperature = 100;
    println("Querying model... ...");
    runModel();
  }
}