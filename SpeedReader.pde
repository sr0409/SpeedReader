//  Developer: Stanley Razumov
//  Program: SpeedReader
//  Date: 02/18/2020

String[] words;
String delimiters = " ,-;.!?";
String fname = "gb.txt";
PFont font;
int currIndex = 0;
int startTime, displayInterval = 500; 
int maxDisplayInterval = 500, minDisplayInterval = 120;
int wpm = 0;
float slider_w = 35;
float slider_h = 10;
float x_pos, y_pos;
boolean focussed = false;
boolean locked = false;
float x_offset;

void setup() {
  String[] lines;
  size(500, 500);
  startTime = millis();
  background(255);
  x_pos = 160;
  y_pos = height - 100;
  
  rectMode(CENTER);
  lines = loadStrings(fname);
  font = createFont("Arial", 28, true);
  String text = join(lines, "");

  words = splitTokens(text, delimiters);

}

void draw() {
   
  background(255);
  textFont(font, 16);
  textAlign(CENTER);
  
  //Text and slider line
  text("Slower",105 , y_pos);
  line (150, y_pos, 350, y_pos);
  text("Faster",395, y_pos);
  
  //Get wpm and set wpm color display accordingly
  textFont(font, 16);
  textAlign(CENTER);
  wpm = maxDisplayInterval + minDisplayInterval - displayInterval;
  if(wpm < 200)
    fill(0, 0, 255);
  else if (wpm > 200 && wpm < 400)
    fill(0, 255, 0);
  else
    fill(255, 0, 0);
  text("WPM: " +  wpm, 50, height -10);
    
  //Handling bug if slider is dragged out of range it will not get out of range values (it will set to min or max) 
  if (displayInterval < minDisplayInterval){
    displayInterval = minDisplayInterval;
  }
  if (displayInterval > maxDisplayInterval){
    displayInterval = maxDisplayInterval;
  }
  if (dist(mouseX, mouseY, x_pos, y_pos) < slider_h) {
    fill(200);
    focussed = true;
  } else {
    fill(255);
    focussed = false;
  }
  
  if (x_pos < 160) {
  x_pos = 160;
  }
  
  if (x_pos > 350) {
  x_pos = 350;
  }

  //Setting up our slider
  rect(x_pos, y_pos, slider_w, slider_h);
  //Checks if array is out of bounds yet, if yes - resets to 0
  if(currIndex < words.length - 1){
    textFont(font, 28);
    textAlign(CENTER);
    fill(0);
    text(words[currIndex], width/2, height/2); 
    } else {
      currIndex = 0;
    }
  //Restarts our timer on switching words
  if (millis() - startTime > displayInterval){
      currIndex++;  
      startTime = millis();  

  }
}

//These functions allow both clicking and dragging the slider
void mousePressed() {
  if (focussed) {
    locked = true;
    x_offset = mouseX-x_pos;
  }
  if(mouseY > y_pos - 5 && mouseY < y_pos + 5)
    x_pos = mouseX;
}
void mouseDragged() {
  if (locked) {
    x_pos = mouseX-x_offset;
  }
}
void mouseReleased() {
  locked = false;
  // The difference between the fastest reading and slowest reading is 380ms
  // The working range of our slider is 190(380 / 2) and it starts at maxDisplayInterval(slowest) @120wpm
  // 350 is our max position of the slider and 160 is the min position
  displayInterval = minDisplayInterval + (int)(350 - x_pos) * 2; 
  
}
//Pause function
void keyPressed(){
  if (key == ' '){
    if(looping)
      noLoop();
    else
     loop();
  }
}
