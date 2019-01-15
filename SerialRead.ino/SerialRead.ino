#include <Servo.h>

bool LightState = false;
int ServoValue;
Servo myServo1;


//Debug Led
const int input01 = 8;
const int output01 =  13;
bool buttonState = false;
int buttonCount = 0;

void setup() {
  Serial.begin(9600);
  pinMode(input01, INPUT);
  pinMode(output01, OUTPUT);
  myServo1.attach(9);

  // init Servo
  myServo1.write(180);
}

void loop() {
  // Read button
  buttonState = digitalRead(input01);
//  Serial.println(buttonState);
  if (buttonState == HIGH) {    
    buttonCount++;
    delay(200);
  }

  if (buttonCount%2==0) {
    myServo1.write(180);
    delay(100);
  } else {
    myServo1.write(0);
    delay(100);
  }


  // Receive
  String s = "";
  while (Serial.available()) {
    char c = Serial.read();
    if (c != '\n') {
      s += c;

      //----Servo 三種階段
      if (s == "q")
        Spray_short();

      if (s == "w")
        Spray_long();

      if (s == "e")
        Spray_stop();

      //----Servo 測試
      //      myServo1.write(StateSelect(s));              // tell servo to go to position in variable 'pos'
      //      delay(15);

      //----LED 測試
      //      if (s == "r")
      //        LightState = true;
      //      else
      //        LightState = false;
      //      delay(5);                                       // 沒有延遲的話 UART 串口速度會跟不上Arduino的速度，會導致資料不完整
    }
    Serial.flush();
  }

  //  Light(LightState);
}

void Light(bool input)
{
  if (input) {
    digitalWrite(output01, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(1000);                       // wait for a second
    digitalWrite(output01, LOW);    // turn the LED off by making the voltage LOW
    delay(1000);
  } else
    digitalWrite(output01, LOW);
}

void Spray_short() {
  myServo1.write(0);              // tell servo to go to position in variable 'pos'
  delay(400);
  myServo1.write(180);              // tell servo to go to position in variable 'pos'
  delay(400);
}

void Spray_long() {
  myServo1.write(0);              // tell servo to go to position in variable 'pos'
  delay(1500);
  myServo1.write(180);              // tell servo to go to position in variable 'pos'
  delay(1000);
}

void Spray_stop() {
  myServo1.write(180);
  delay(30);
}

int StateSelect(String input) {
  if (input == "q")
    return 1;
  else if (input == "w")
    return 30;
  else if (input == "e")
    return 60;
  else if (input == "r")
    return 90;
  else if (input == "t")
    return 120;
  else if (input == "y")
    return 150;
  else if (input == "u")
    return 179;
  else
    return 1;
}
