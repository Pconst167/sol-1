/*
  dal0..dal7: 0 .. 7 
  mr: 8
  cs: 9
  a0: 10 
  a1: 11
  rw: 12
  drq: 13
  intrq: ana0
  dden:  ana1
*/

// Pin definitions
#define DAL0 0
#define DAL1 1
#define DAL2 2
#define DAL3 3
#define DAL4 4
#define DAL5 5
#define DAL6 6
#define DAL7 7

#define MR 8
#define CS 9
#define ADDR0 10
#define ADDR1 11
#define RW 12
#define DRQ 13

#define INTRQ A0
#define DDEN A1



void setDataAsOutput(){
  for (int i = DAL0; i <= DAL7; i++) {
    pinMode(i, OUTPUT);
  }
}
void setDataAsInput(){
  for (int i = DAL0; i <= DAL7; i++) {
    pinMode(i, INPUT);
  }
}

void seekTrack(byte track) {  
  byte stat;

  setDataAsInput();
  digitalWrite(ADDR0, LOW);  // 
  digitalWrite(ADDR1, LOW);  // Select status register
  digitalWrite(RW, HIGH);  // Set for read operation
  digitalWrite(CS, LOW);
  for(;;){
    delayMicroseconds(1);
    Serial.println("Waiting for busy bit to become 0...");
    stat = readDataBus();
    Serial.print("status reg: "); 
    Serial.println(stat);
    stat = stat & 0x01; // isolate busy bit
    if(!stat) break;
  }
  digitalWrite(CS, HIGH);
  Serial.println("Busy bit is now 0...");
  Serial.println("Now setting data register with track number...");

  
  digitalWrite(RW, LOW);  // Set for write operation
  setDataAsOutput();
  digitalWrite(ADDR0, HIGH);  // 
  digitalWrite(ADDR1, HIGH);  // Select data register
  // Load track value into data register
  setDataBus(track);  // set track 
  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(1);
  digitalWrite(CS, HIGH);

  delay(500);

  Serial.println("Sending Seek command...");
  setDataAsOutput();
  digitalWrite(ADDR0, LOW);  // 
  digitalWrite(ADDR1, LOW);  // Select command register
  digitalWrite(RW, LOW);  // Set for write operation
  // Load Restore command (0x0F) into data bus
  setDataBus(0x13);  // 0001_0011  step rate = 30ms
  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(1);
  digitalWrite(CS, HIGH);

  // Wait for INTRQ to go HIGH, indicating command completion
  Serial.println("Waiting for IRQ...");
  while (digitalRead(INTRQ) != HIGH){
    Serial.println("Waiting for IRQ.");
  }
  Serial.println("IRQ received!");
  delay(500);

  setDataAsInput(); // set data lines as inputs
  // Check if we are on right track  by reading the track register
  digitalWrite(ADDR0, HIGH);  // Select track register
  digitalWrite(ADDR1, LOW); // Select track register
  digitalWrite(RW, HIGH); // Set for read operation
  digitalWrite(CS, LOW); // Enable chip select
  delayMicroseconds(2);
  byte trackReg = readDataBus();
  digitalWrite(CS, HIGH);  // Disable chip select
  Serial.print("Value of Track register: ");
  Serial.println(trackReg);
}


void setDataBus(byte data) {
  for (int i = 0; i < 8; i++) {
    digitalWrite(DAL0 + i, (data >> i) & 0x01);
  }
}

byte readDataBus() {
  byte data = 0;
  if(digitalRead(DAL0)) data |= 1;
  if(digitalRead(DAL1)) data |= 2;
  if(digitalRead(DAL2)) data |= 4;
  if(digitalRead(DAL3)) data |= 8;
  if(digitalRead(DAL4)) data |= 16;
  if(digitalRead(DAL5)) data |= 32;
  if(digitalRead(DAL6)) data |= 64;
  if(digitalRead(DAL7)) data |= 128;

  return data;
}

void waitForEnter() {
  while (true) {
    if (Serial.available() > 0) {
      char c = Serial.read();
      if (c == '\n') {  // Check for the newline character
        break;
      }
    }
  }
}

void updateStatus(){
  setDataAsOutput();
  digitalWrite(ADDR0, LOW);  // 
  digitalWrite(ADDR1, LOW);  // Select command register
  digitalWrite(RW, LOW);  // Set for write operation
  // Load Restore command into data bus
  setDataBus(0xD0);  // 1101_0000

  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(1);
  digitalWrite(CS, HIGH);
}

void printDataReg(){
  byte dataReg;
  // read data register
  digitalWrite(ADDR0, HIGH);  // 
  digitalWrite(ADDR1, HIGH);  // Select data register
  digitalWrite(RW, HIGH);  // Set for read operation
  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(2);
  dataReg = readDataBus(); // read status register
  digitalWrite(CS, HIGH);
  Serial.print("Data Register: ");
  Serial.println(dataReg);
}
void printStatus(){
  byte statusReg;
  // read status register
  digitalWrite(ADDR0, LOW);  // 
  digitalWrite(ADDR1, LOW);  // Select status register
  digitalWrite(RW, HIGH);  // Set for read operation
  // Pulse the chip select line to latch the command
  digitalWrite(CS, LOW);
  delayMicroseconds(2);
  statusReg = readDataBus(); // read status register
  digitalWrite(CS, HIGH);
  Serial.print("Status Register: ");
  Serial.println(statusReg);
}

void setup() {
  byte statusReg;
  
  Serial.begin(9600);
  while (!Serial) {
    ; // Wait for serial port to connect. Needed for native USB
  }
 
  // Set control lines as outputs
  Serial.println("Setting Control Lines...");
  pinMode(MR,   OUTPUT);
  pinMode(CS,   OUTPUT);
  pinMode(ADDR0,   OUTPUT);
  pinMode(ADDR1,   OUTPUT);
  pinMode(RW,   OUTPUT);
  pinMode(DDEN, OUTPUT);
  pinMode(DRQ,   INPUT);
  pinMode(INTRQ, INPUT);

  // set values for the output pins
  digitalWrite(MR,   LOW);
  digitalWrite(CS,   HIGH);
  digitalWrite(ADDR0,   LOW);
  digitalWrite(ADDR1,   LOW);
  digitalWrite(RW,   HIGH); // select read mode
  digitalWrite(DDEN, HIGH); // select low density mode

  setDataAsInput(); // set dat  a lines as inputs
  
  // reset the WD1770  
  delay(400);              // Hold reset for 10ms
  digitalWrite(MR, HIGH); // Release Master Reset

  printStatus();
  Serial.println("Press Enter to move head to track 0...");
  waitForEnter();
  // Seek to track 0
  Serial.println("Seeking to Track00...");
  printStatus();
/*
  Serial.println("Press Enter again to move head to track 5...");
  waitForEnter();
  seekTrack(5);
  printDataReg();
  printStatus();
*/
  Serial.println("Finished.");

  setDataAsInput();
}

void loop() {
  // Main loop does nothing, as the task is completed in setup
}
