//created on 10.26
//by XU TONGDA for sample training

import controlP5.Accordion;
import controlP5.ControlP5;
import controlP5.Group;
import controlP5.RadioButton;
import controlP5.Toggle;
import processing.core.*;
import processing.opengl.PGraphics2D;
import netP5.*;
import oscP5.*;
import processing.video.*;


ControlP5 cp5;
OscP5 oscP5;
NetAddress dest;
Movie myMovie;
PrintWriter output;
PrintWriter record;

PImage img;

String fileName;
String imgTag;
String textDisplay;
String returnType;
int imgTagInt;


int iliterationTime;
int imgNum;
int counter;
int nameCounter = 5;
int unitLength = 176;
int videoLength;
int imageCounter;
int globalType;
String peopleType;
String number;

float A;
float B;
float alpha;
float beta;
float delta;
float theta;
float gamma;
float pastTemp;

void setup() {
  
  globalType =3;
  peopleType = "07";
  
  if (globalType == 1){
  A = 0.5;
  B = 101.5;
  } 
  else if (globalType == 2){
  A = 101.5;
  B = 178.5;
  } 
  else if (globalType == 3){
  A = 178.5;
  B = 280.5;
  } 
  else if (globalType == 4){
  A = 280.5;
  B = 350.5;
  } 
  else if (globalType == 5){
  A = 350.5;
  B = 420.5;
  } 
  else if (globalType == 6){
  A = 420.5;
  B = 525.5;
  } 
  else if (globalType == 7){
  A = 525.5;
  B = 640.5;
  } 
  else if (globalType == 8){
  A = 640.5;
  B = 807.5;
  } 
  
  number = peopleType+"_"+globalType;

  oscP5 = new OscP5(this, 12000);
  dest = new NetAddress("127.0.0.1", 6448);
  myMovie = new Movie(this, "C:/BoxOfJoy/Experiment/prevideo.avi");
  output = createWriter("result_"+year()+"_"+month()+"_"+day()+"_"+hour()+"_"+second()+".txt");
  record = createWriter("record_"+year()+"_"+month()+"_"+day()+"_"+number+".txt");
  size(1600, 1200);
  frameRate(15);


  background(0, 0, 0);
  imageCounter = 0;

  imgNum = 10;
  imgTag = "preparation";
  
  iliterationTime = 90;
  counter = 0;
  videoLength = 2;

  initialOsc();
  endModelRecord();
  guiSetup();
  myMovie.play();
}

void aftersetup(){

  

}

void draw() {

  scale(2);

  textSize(15);
  fill(255);
  
  println("draw");
 if (counter >1 && counter <videoLength + 1) {

    background(0, 0, 0);
  } else if (counter>videoLength + 1&&counter%iliterationTime == 1) {

    background(0, 0, 0);

    textDisplay = Imageswift(imgNum);
    //text(textDisplay, 10, 30); 

    imgNum = floor(random(A, B));
    imageCounter ++;

    startModelRecord();
    setClass(imgTagInt);
  } else if (counter>videoLength + 300&&counter%iliterationTime == iliterationTime - 15) {

    background(0, 0, 0);

    endModelRecord();
  }
  
  if(imageCounter>11){
    endOsc();
    background(0,0,0);
  
  }

  messageProcessing();

  counter++;
}


String Imageswift(int imageindex) {


  fileName = "C:/BoxOfJoy/testImages_artphoto/img_ ("+imageindex+").jpg";
  img = loadImage(fileName);
  image(img, width/4-img.width/2, height/4-img.height/2);


  if (imageindex>0.5&&imageindex<101.5) {
    imgTag = "Amusement";
    imgTagInt = 1;
  } else if (imageindex>101.5&&imageindex<178.5) {
    imgTag = "Anger";
    imgTagInt = 2;
  } else if (imageindex>178.5&&imageindex<280.5) {
    imgTag = "Awe";
    imgTagInt = 3;
  } else if (imageindex>280.5&&imageindex<350.5) {
    imgTag = "Contentment";
    imgTagInt = 4;
  } else if (imageindex>350.5&&imageindex<420.5) {
    imgTag = "Disguist";
    imgTagInt = 5;
  } else if (imageindex>420.5&&imageindex<525.5) {
    imgTag = "Excitement";
    imgTagInt = 6;
  } else if (imageindex>525.5&&imageindex<640.5) {
    imgTag = "Fear";
    imgTagInt = 7;
  } else if (imageindex>640.5&&imageindex<807.5) {
    imgTag = "Anger";
    imgTagInt = 8;
  }

  return imgTag;
}

void guiSetup() {

  cp5 = new ControlP5(this);

  // to variable 'imgNum' 
  cp5.addSlider("imgNum")
    .setPosition(5, 50)
    .setRange(1, 807)
    ;

  // to variable 'iliteration' 
  cp5.addSlider("iliterationTime")
    .setPosition(5, 35)
    .setRange(50, 1500)
    ;
}


void backZero() {

  alpha = 0;
  beta = 0;
  delta = 0;
  theta = 0;
  gamma = 0;
}

void initialOsc() {

  OscMessage msg = new OscMessage("/wekinator/control/startRecording");
  msg.add("Start recording examples");
  oscP5.send(msg, dest);
}

void endOsc() {

  OscMessage msg = new OscMessage("/wekinator/control/stopRecording");
  msg.add("Stop recording examples");
  oscP5.send(msg, dest);
}



void startModelRecord() {

  OscMessage msg = new OscMessage("/wekinator/control/enableModelRecording");
  msg.add(1);
  oscP5.send(msg, dest);
}

void endModelRecord() {

  OscMessage msg = new OscMessage("/wekinator/control/disableModelRecording");
  msg.add(1);
  oscP5.send(msg, dest);
}

void setClass(int c) {

  OscMessage msg = new OscMessage("/wekinator/control/outputs");
  println("setting class to " + c);
  msg.add((float)c); 
  oscP5.send(msg, dest);
}

void messageProcessing() {

  OscMessage msg = new OscMessage("/wek/inputs");
  String[] lines = loadStrings("D:/Users/Administrator/Documents/Processing/OpenBCI_Processing-master/OpenBCI_GUI/FFT_20171030.txt");
  int last = lines.length;
  int fullRound = floor (last/unitLength);
  pastTemp = alpha;

  for (int i=0; i<=unitLength-1; i++) {


    float temp = Float.valueOf(lines[(fullRound-1)*unitLength+i]);
    msg.add(temp);
    record.print(temp);

    int ind = i%22;

    if (ind>2.5 && ind<5.5) {
      alpha += temp;
    }

    if (ind>4.5 && ind<11.5) {
      beta += temp;
    }

    if (ind>0.5 && ind<2.5) {
      delta += temp;
    }

    if (ind>1.5 && ind<3.5) {
      theta += temp;
    }

    if (ind>11.5 && ind<21.5) {
      gamma += temp;
    }
  }
  record.println("/"+","+imgTag);

  //println(alpha+"and"+pastTemp);

  if (alpha != pastTemp)
  {
    oscP5.send(msg, dest);
    //println("record");
    
  }
}

void movieEvent(Movie m) {
  m.read();
}

void oscEvent(OscMessage theOscMessage) {
  int returnInt;
  String returnEmotion;
  /* get and print the address pattern and the typetag of the received OscMessage */
  //println("### received an osc message with addrpattern "+theOscMessage.addrPattern()+" and typetag "+theOscMessage.typetag());
  //theOscMessage.print();
  if (theOscMessage.checkTypetag("f")) {
    returnInt =  (int) theOscMessage.get(0).floatValue();
  } else {
    returnInt = -1;
  }

  if (returnInt == 1) {

    returnEmotion = "Amusement";
  } else if (returnInt == 2) {

    returnEmotion = "Anger";
  } else if (returnInt == 3) {

    returnEmotion = "Awe";
  } else if (returnInt == 4) {

    returnEmotion = "Contentment";
  } else if (returnInt == 5) {

    returnEmotion = "Disguist";
  } else if (returnInt == 6) {

    returnEmotion = "Excitement";
  } else if (returnInt == 7) {

    returnEmotion = "Fear";
  } else if (returnInt == 8) {

    returnEmotion = "Anger";
  }
  else{
  
  returnEmotion = "nullpoint";
  }
  fill(0);
  rect(8,68,95,20);
  fill(255);
  //text(returnEmotion, 10, 80);
  
  output.println(day()+","+hour()+","+minute()+","+second()+"/ImageMeaning:"+imgTag+"/"+"learningResult:"+returnEmotion);

}


void keyPressed() {

  if (key == '1') {
    initialOsc();
  } else if (key == '2') {
    endOsc();
  }
}