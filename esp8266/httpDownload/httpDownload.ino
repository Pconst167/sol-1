#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <LittleFS.h>

const int MAX_CLIENTS = 4;
const char* ssid = "";
const char* password = "";
uint8_t buffer[32 * 1024];
int len;
int baud = 9600;

WiFiServer server(51515); // Telnet server on port 23
WiFiClient serverClients[MAX_CLIENTS];

String commandBuffer = "";


void setup() {
  //ESP.wdtEnable(60000);  // 60 seconds timeout
  Serial.begin(baud);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
  }
  server.begin();
}

void loop() {
  int len = 0;
  for (uint8_t i = 0; i < MAX_CLIENTS; i++) {
    if (serverClients[i] && serverClients[i].connected()) {
      while (serverClients[i].available()) {
        char c = serverClients[i].read();
        if(c != 0x0D) Serial.write(c);
        if(len % 100 == 0) yield();  // Yield every 100 iterations
        if(len % 512 == 0) delay(200);
        len++;
      }
    }
  }

  if (server.hasClient()) {
    for (int i = 0; i < MAX_CLIENTS; i++) {
      // Find first available slot for new client
      if (!serverClients[i] || !serverClients[i].connected()) {
        if (serverClients[i]) serverClients[i].stop();
        serverClients[i] = server.available();
        continue;
      }
    }
    // No slots available, reject additional client
    WiFiClient serverClient = server.available();
    serverClient.stop();
  }

  while (Serial.available()) {
    char c = Serial.read();
    sendCharToAllClients(c);

    if (c == '\n') {
      if(commandBuffer != ""){
        processCommand(commandBuffer);
        commandBuffer = "";  // Clear the buffer
      }
    }
    else{  
      commandBuffer += c;
    }
  }
}

void sendCharToAllClients(char c){
  for (int i = 0; i < MAX_CLIENTS; i++) {
      if (serverClients[i] && serverClients[i].connected()) {
        serverClients[i].write(c);
      }
    }
}


void sendStrToAllClients(String s){
  int j;
  for (int i = 0; i < MAX_CLIENTS; i++) {
      if (serverClients[i] && serverClients[i].connected()) {
        for(j=0;j<s.length();j++)
          serverClients[i].write(s[j]);
      }
    }
}

void processCommand(const String& command) {
  char cmd;
  if (command[0] == '~') { // Command Flag
    cmd = command[1];
    switch(cmd){
      case '0':{
        String baudRateStr = command.substring(3, command.lastIndexOf(")"));
        long Baud = baudRateStr.toInt();
        if (Baud > 0) {
          Serial.begin(Baud);
        } 
        break;
      }
      case '1':{  // download and display only (browse)
        String url = command.substring(3, command.lastIndexOf(")"));
        downloadFile(url, 32*1024);
        for(int i = 0; i < len; i++) {
          sendCharToAllClients(buffer[i]);
          if(i % 100 == 0) yield();  // Yield every 100 iterations
        }
        break;
      }
      case '2':{  // download and send status
        String url = command.substring(3, command.lastIndexOf(")"));
        String _status = String(downloadFile(url, 1024*16 - 1));
        buffer[len] = 0;
        delay(3000);
        Serial.print(String(_status) + "\n");
        break;
      }
      case '3':{  // send file
        delay(3000);
        for(int i = 0; i < len; i++) {
          Serial.write(binToAscii(buffer[i] >> 4));
          Serial.write(binToAscii(buffer[i] & 0x0F));
          if(i % 100 == 0) yield();  // Yield every 100 iterations
          else if(i % 512 == 0) delay(200);
        }
        delay(1000);
        Serial.write(0x0A); // End stream 
        delay(1000);
        break;
      }
      case '4':{  // get file size
        String url = command.substring(3, command.lastIndexOf(")"));
        String _status = String(getFileSize(url));
        delay(3000);
        Serial.print(_status + ":" + String(len) + "\n");
        break;
      }
      default:{
        Serial.write("cmd_unknown\n");
        break;
      }
    }
  }
}

int downloadFile(String url, int maxSize) {
  HTTPClient http;
  WiFiClient client;
  int _status;

  
  http.begin(client, url);
  int httpCode = http.GET();
  _status = httpCode;
    
  if(httpCode == HTTP_CODE_OK){
    len = http.getSize();
    
    if(len > maxSize) {
      len = maxSize; 
    }
    
    WiFiClient stream = http.getStream();
    stream.readBytes(buffer, len);
    buffer[len] = 0;  // Null-terminate if used as string
  } 

  http.end();
  return _status;
}


int getFileSize(String url) {
  HTTPClient http;
  WiFiClient client;
  int _status;
  
  http.begin(client, url);
  int httpCode = http.GET();
   _status = httpCode;
   
  if(httpCode == HTTP_CODE_OK) {
    len = http.getSize();  
  } 

  http.end();
  return _status;
}



// 0x00 to 0xFF
char binToAscii(char bin){
  switch(bin){
    case 0:
      return '0';
    case 1:
      return '1';
     case 2:
      return '2';
     case 3:
      return '3';
     case 4:
      return '4';
     case 5:
      return '5';
     case 6:
      return '6';
     case 7:
      return '7';
     case 8:
      return '8';
     case 9:
      return '9';
     case 0xA:
      return 'A';
     case 0xB:
      return 'B';
     case 0xC:
      return 'C';
     case 0xD:
      return 'D';
     case 0xE:
      return 'E';
     case 0xF:
      return 'F';
     default:
       return '0';
  }
}
