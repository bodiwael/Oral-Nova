/*
 * ESP32 Bite Force Sensor with Bluetooth
 * Reads force sensor (FSR - Force Sensitive Resistor) and sends data via BLE
 */

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// BLE UUIDs
#define SERVICE_UUID        "4fafc202-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a9"

// Sensor Configuration
#define FORCE_SENSOR_PIN 34  // Analog pin for FSR (ADC1_CH6)
#define LED_PIN 2            // Built-in LED for status

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// Calibration values (adjust based on your sensor)
const int MIN_RAW_VALUE = 0;
const int MAX_RAW_VALUE = 4095;  // ESP32 ADC is 12-bit (0-4095)
const float MAX_FORCE_NEWTONS = 100.0;  // Maximum force in Newtons

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      digitalWrite(LED_PIN, HIGH);
      Serial.println("Device connected");
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      digitalWrite(LED_PIN, LOW);
      Serial.println("Device disconnected");
    }
};

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  pinMode(FORCE_SENSOR_PIN, INPUT);

  Serial.println("Bite Force Sensor with BLE");

  // Create the BLE Device
  BLEDevice::init("BiteForce_ESP32");

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

float readBiteForce() {
  // Read analog value from FSR
  int rawValue = analogRead(FORCE_SENSOR_PIN);

  // Apply moving average filter for stability (optional)
  static int readings[10];
  static int readIndex = 0;
  static int total = 0;

  total = total - readings[readIndex];
  readings[readIndex] = rawValue;
  total = total + readings[readIndex];
  readIndex = (readIndex + 1) % 10;

  int average = total / 10;

  // Convert to force (Newtons) - linear mapping
  // You may need to calibrate this based on your specific FSR
  float force = map(average, MIN_RAW_VALUE, MAX_RAW_VALUE, 0, MAX_FORCE_NEWTONS * 10) / 10.0;

  // Ensure non-negative values
  if (force < 0) force = 0;

  return force;
}

void loop() {
  // Read bite force
  float biteForce = readBiteForce();

  // Print to Serial Monitor
  Serial.print("Bite Force: ");
  Serial.print(biteForce);
  Serial.println(" N");

  // Send via BLE if connected
  if (deviceConnected) {
    String data = String(biteForce, 1) + "\n";
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

  delay(100);  // 10 Hz update rate
}
