import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import oscP5.*;
import controlP5.*;

KetaiBluetooth bt;
KetaiList klist;
ControlP5 cp5;

public String selectName;
boolean ShowInfo = false;
int boxWidth = 150*2;
int value01=255;

String pairInfo;
String[] devicesName = {};
PFont mono;

int AllFontSize;

//********************************************************************
// The following code is required to enable bluetooth at startup.
//********************************************************************
void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
  println("Creating KetaiBluetooth");
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}
//********************************************************************



void setup()
{   
  fullScreen();
  orientation(PORTRAIT);

  //size(720, 1280);
  AllFontSize = height/32;

  background(0);
  cp5 = new ControlP5(this);   

  mono = createFont("Calibri", AllFontSize);
  textFont(mono);


  ControlFont font = new ControlFont(mono);
  cp5.setFont(font);

  InfoToggle(new PVector(0, 0));
  DrawButton(new PVector(width/2, height/2));
  ShowPairDevices(new PVector(50, 170), 20);
}


void draw() {
}




void mousePressed() {
  float mpx = mouseX;
  float mpy = mouseY;


  //---- Setting
  if ( (mpx>0 && mpx<width && mpy > 0 && mpy < AllFontSize*2) ) {
    try {
      DevicesSelect();
    }
    catch(Exception e) {
    }
  }

  int boxWidth = round(AllFontSize*2*2.5f);
  int boxHeight = round(AllFontSize*2*2.5f);


  if ( (mpx>width/2-boxWidth/2 && mpx<width/2+boxWidth/2 && mpy > height/2-boxHeight/2 && mpy < height/2+boxHeight/2) ) {
    try {
      Button01();
    }
    catch(Exception e) {
    }
  }

  if ( (mpx>width/2-boxWidth/2 && mpx<width/2+boxWidth/2 && mpy > height/2-boxHeight/2+boxHeight*1.5f && mpy < height/2+boxHeight/2+boxHeight*1.5f) ) {
    try {
      Button02();
    }
    catch(Exception e) {
    }
  }
  
  
}

void InfoToggle(PVector _pos) {  

  pushStyle();


  fill(100, 100, 255, 200);
  rect(_pos.y, _pos.y, width, AllFontSize*2);

  fill(255);
  textAlign(CENTER);
  textSize(AllFontSize);
  text("DevicesSelect", width/2, AllFontSize+AllFontSize/2);

  popStyle();

  //cp5.addButton("DevicesSelect")
  //  .setSize(round(AllFontSize*2*2*1.7), AllFontSize*2*2)
  //  .setPosition(_pos.x, _pos.y)
  //;
}


void ShowPairDevices(PVector _pos, int size) {

  try
  {
    devicesName = bt.getPairedDeviceNames().toArray(new String[bt.getPairedDeviceNames().size()]);
  }
  catch(Exception e) {
  }

  textSize(size);
  text("Pair devices:", _pos.x, _pos.y);  

  fill(100, 100, 255);
  textSize(size*.8f);
  for (int i=0; i<devicesName.length; i++)
    text(devicesName[i], _pos.x, _pos.y+i*25+25);
}


void DrawButton(PVector _pos) 
{
  int boxWidth = round(AllFontSize*2*2.5f);
  int boxHeight = round(AllFontSize*2*2.5f);

  pushStyle();

  //Button1
  fill(255, 255, 100);
  rect(_pos.x-boxWidth/2, _pos.y-boxHeight/2, boxWidth, boxHeight);

  fill(0);
  textAlign(CENTER);
  textSize(AllFontSize);
  text("Button1", _pos.x, _pos.y);

  //Button2
  fill(255, 255, 100);
  rect(_pos.x-boxWidth/2, _pos.y-boxHeight/2+boxHeight*1.5f, boxWidth, boxHeight);

  fill(0);
  textAlign(CENTER);
  textSize(AllFontSize);
  text("Button2", _pos.x, _pos.y+boxHeight*1.5f);

  popStyle();

  //cp5.addButton("Button01")
  //  .setPosition(_pos.x-boxWidth/2, _pos.y-boxHeight/2)
  //  .setSize(boxWidth, boxHeight)
  //  ;      

  //cp5.addButton("Button02")
  //  .setPosition(_pos.x-boxWidth/2, _pos.y-boxHeight/2+boxHeight*1.5f)
  //  .setSize(boxWidth, boxHeight)
  //  ;
}

void Button01() {
  byte[] data = new byte[]{'q', 2};
  bt.writeToDeviceName(selectName, data);
  print("q");
}


void Button02() {
  byte[] data = new byte[]{'w', 2};
  bt.writeToDeviceName(selectName, data);
  print("w");
}

void DevicesSelect() {
  listState = CONNECT_LIST;
  if (bt.getDiscoveredDeviceNames().size() > 0) {
    ArrayList<String> list = bt.getDiscoveredDeviceNames();
    list.add("CANCEL");
    klist = new KetaiList(this, list);
  } else if (bt.getPairedDeviceNames().size() > 0) {
    ArrayList<String> list = bt.getPairedDeviceNames();
    list.add("CANCEL");
    klist = new KetaiList(this, list);
  }
}
