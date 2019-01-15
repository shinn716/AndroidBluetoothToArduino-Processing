package processing.test.bluetoothtest01;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.net.bluetooth.*; 
import ketai.ui.*; 
import ketai.net.*; 
import oscP5.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class BluetoothTest01 extends PApplet {

//import android.content.Intent;
//import android.os.Bundle;








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
//void onCreate(Bundle savedInstanceState) {
//  super.onCreate(savedInstanceState);
//  bt = new KetaiBluetooth(this);
//  println("Creating KetaiBluetooth");
//}

//void onActivityResult(int requestCode, int resultCode, Intent data) {
//  bt.onActivityResult(requestCode, resultCode, data);
//}
//********************************************************************



public void setup()
{   
  
  orientation(PORTRAIT);

  //size(720, 1280);
  AllFontSize = height/32;

  background(0);
  cp5 = new ControlP5(this);   

  mono = createFont("Calibri", AllFontSize);
  textFont(mono);

  
   ControlFont font = new ControlFont(mono);
   cp5.setFont(font);
  
  InfoToggle(new PVector(50, 30));
  DrawButton(new PVector(width/2, height/2));
  ShowPairDevices(new PVector(50, 100), AllFontSize/2);
}

public void draw(){}

public void InfoToggle(PVector _pos) {  

  cp5.addButton("DevicesSelect")
    .setSize(round(AllFontSize*2*2*1.7f), AllFontSize*2*2)
    .setPosition(_pos.x, _pos.y)
    ;
}

public void ShowPairDevices(PVector _pos, int size) {

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

public void DrawButton(PVector _pos) 
{
  int boxWidth = round(AllFontSize*2*2.5f);
  int boxHeight = round(AllFontSize*2*2.5f);

  cp5.addButton("Button01")
    .setPosition(_pos.x-boxWidth/2, _pos.y-boxHeight/2)
    .setSize(boxWidth, boxHeight)
    ;      

  cp5.addButton("Button02")
    .setPosition(_pos.x-boxWidth/2, _pos.y-boxHeight/2+boxHeight*1.5f)
    .setSize(boxWidth, boxHeight)
    ;
}

public void Button01() {
  byte[] data = new byte[]{'q', 2};
  bt.writeToDeviceName(selectName, data);
}


public void Button02() {
  byte[] data = new byte[]{'w', 2};
  bt.writeToDeviceName(selectName, data);
}

public void DevicesSelect() {
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
/*  UI-related functions */
int CONNECT_LIST = 0; 
int DISCONNECT_LIST = 1;
int listState = CONNECT_LIST;

public void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  selectName = selection;
  
  if (listState == CONNECT_LIST)
  {
    if (!selection.equals("CANCEL"))
      bt.connectToDeviceByName(selection);
  }else if (listState == DISCONNECT_LIST)
  {
     bt.disconnectDevice(selection); 
  }
  //dispose of list for now
  klist = null;
}
  public void settings() {  fullScreen(); }
}
