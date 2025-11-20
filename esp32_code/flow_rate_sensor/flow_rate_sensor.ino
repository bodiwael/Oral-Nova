/*
 * ESP32 Flow Rate Sensor with Bluetooth
 * Reads dual flow sensors (Inhale/Exhale) and sends data via BLE
 * Based on Arduino Uno code - adapted for ESP32
 */

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// BLE UUIDs
#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

// Sensor pins (ESP32 has hardware serial ports)
#define RXD1 16  // RX pin for Sensor 1 (Inhale)
#define TXD1 17  // TX pin for Sensor 1 (Inhale)
#define RXD2 25  // RX pin for Sensor 2 (Exhale)
#define TXD2 26  // TX pin for Sensor 2 (Exhale)

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

float flowRate1 = 0.0;  // Inhale sensor
float flowRate2 = 0.0;  // Exhale sensor

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      Serial.println("Device connected");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      Serial.println("Device disconnected");
    }
};

void setup() {
  Serial.begin(115200);

  // Initialize hardware serial ports for sensors
  Serial1.begin(9600, SERIAL_8N1, RXD1, TXD1);  // Sensor 1
  Serial2.begin(9600, SERIAL_8N1, RXD2, TXD2);  // Sensor 2

  Serial.println("Dual Flow Sensor with BLE");

  // Create the BLE Device
  BLEDevice::init("FlowRate_ESP32");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);
  BLEDevice::startAdvertising();

  Serial.println("BLE advertising started. Waiting for connection...");
}

void loop() {
  // Read Sensor 1 (Inhale)
  if (Serial1.available() >= 9) {
    uint8_t header = Serial1.read();

    if (header == 0x16) {
      uint8_t buffer[8];
      for (int i = 0; i < 8; i++) {
        buffer[i] = Serial1.read();
      }

      if (buffer[0] == 0x09 && buffer[1] == 0x01) {
        flowRate1 = (buffer[4] * 256 + buffer[5]) / 10.0;
        flowRate1 *= 2;  // Apply scaling factor
      }
    }
  }

  // Read Sensor 2 (Exhale)
  if (Serial2.available() >= 9) {
    uint8_t header = Serial2.read();

    if (header == 0x16) {
      uint8_t buffer[8];
      for (int i = 0; i < 8; i++) {
        buffer[i] = Serial2.read();
      }

      if (buffer[0] == 0x09 && buffer[1] == 0x01) {
        flowRate2 = (buffer[4] * 256 + buffer[5]) / 10.0;
        flowRate2 *= 2;  // Apply scaling factor
      }
    }
  }

  // Print to Serial Monitor
  Serial.print("Inhale: ");
  Serial.print(flowRate1);
  Serial.print(" L/min, Exhale: ");
  Serial.print(flowRate2);
  Serial.println(" L/min");

  // Send via BLE if connected
  if (deviceConnected) {
    // Format: "Inhale,Exhale\n"
    String data = String(flowRate1, 1) + "," + String(flowRate2, 1) + "\n";
    pCharacteristic->setValue(data.c_str());
    pCharacteristic->notify();
  }

  // Handle disconnection
  if (!deviceConnected && oldDeviceConnected) {
    delay(500);
    pServer->startAdvertising();
    Serial.println("Start advertising");
    oldDeviceConnected = deviceConnected;
  }

  // Handle connection
  if (deviceConnected && !oldDeviceConnected) {
    oldDeviceConnected = deviceConnected;
  }

  delay(100);  // Update rate
}
