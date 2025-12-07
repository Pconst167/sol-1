#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <LittleFS.h>

// WiFi credentials (insert your SSID and password)
const char* ssid = "";
const char* password = "";
// Serial settings
uint16_t baud = 38400;  // Change if needed

// Telnet settings
const int MAX_CLIENTS = 1;
WiFiServer server(51515);
WiFiClient serverClients[MAX_CLIENTS];

// Buffer size
#define SERIAL_BUFFER_SIZE 64
#define BURST_DELAY_US 100  // 100 microseconds between bursts

void setup() {
  Serial.setRxBufferSize(1024);
  Serial.begin(38400, SERIAL_8O2);

  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");

  server.begin();
  server.setNoDelay(true);  // Disable Nagle to reduce latency
}

void loop() {
  // Accept new Telnet clients
  if (server.hasClient()) {
    WiFiClient newClient = server.available();
    bool added = false;
    for (int i = 0; i < MAX_CLIENTS; i++) {
      if (!serverClients[i] || !serverClients[i].connected()) {
        if (serverClients[i]) serverClients[i].stop();
        serverClients[i] = newClient;
        added = true;
        break;
      }
    }
    if (!added) {
      newClient.stop();  // All slots full
    }
  }

  // Telnet → Serial
  for (uint8_t i = 0; i < MAX_CLIENTS; i++) {
    if (serverClients[i] && serverClients[i].connected() && serverClients[i].available()) {
      while (serverClients[i].available()) {
        char c = serverClients[i].read();
        if (c != '\r') {
          if (Serial.availableForWrite() > 0) {
            Serial.write(c);
            Serial.flush();       // Wait for TX complete
            delayMicroseconds(BURST_DELAY_US);  // Delay per byte
          }
        }
      }
    }
  }

  // Serial → Telnet (buffered)
  static uint8_t buffer[SERIAL_BUFFER_SIZE];
  int len = 0;

  while (Serial.available() && len < SERIAL_BUFFER_SIZE) {
    buffer[len++] = Serial.read();
  }

  if (len > 0) {
    for (int i = 0; i < MAX_CLIENTS; i++) {
      if (serverClients[i] && serverClients[i].connected()) {
        serverClients[i].write(buffer, len);
        delayMicroseconds(BURST_DELAY_US);  // Delay per burst
      }
    }
  }

  yield();  // Feed the watchdog
}
