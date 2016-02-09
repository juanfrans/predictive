import java.io.*;

void setup(){
  size(200,200);
}

void draw(){
  
}

void mousePressed(){
  Process result = launch("/Users/juansaldarriaga/Google_Drive/02_Freelancing/02_Projects/1505_Taxi_Predictions/05_Processing/02_Sketches/sketch_160202d/data/python hello.py");
  println("opening app...");
  println(result);
  
}