/*
 * ESP32 Tongue Movement Sensor with Bluetooth
 * Reads flex sensor and sends data via BLE
 */

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// BLE UUIDs
#define SERVICE_UUID        "4fafc203-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26aa"

// Sensor Configuration
#define FLEX_SENSOR_PIN 35   // Analog pin for flex sensor (ADC1_CH7)
#define LED_PIN 2            // Built-in LED for status

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;

// Calibration values (adjust based on your flex sensor)
// Measure these values when sensor is straight and fully bent
const int STRAIGHT_VALUE = 1800;  // ADC value when straight
const int BENT_VALUE = 3000;      // ADC value when fully bent
const float MAX_ANGLE = 90.0;     // Maximum bend angle in degrees

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
  pinMode(FLEX_SENSOR_PIN, INPUT);

  Serial.println("Tongue Movement Sensor with BLE");

  // Create the BLE Device
  BLEDevice::init("Tongue_ESP32");

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

float readTongueMovement() {
  // Read analog value from flex sensor
  int rawValue = analogRead(FLEX_SENSOR_PIN);

  // Apply moving average filter for stability
  static int readings[10];
  static int readIndex = 0;
  static int total = 0;

  total = total - readings[readIndex];
  readings[readIndex] = rawValue;
  total = total + readings[readIndex];
  readIndex = (readIndex + 1) % 10;

  int average = total / 10;

  // Convert to angle (degrees)
  float angle = map(average, STRAIGHT_VALUE, BENT_VALUE, 0, MAX_ANGLE * 10) / 10.0;

  // Clamp to valid range
  if (angle < 0) angle = 0;
  if (angle > MAX_ANGLE) angle = MAX_ANGLE;

  // Convert to percentage (0-100%)
  float percentage = (angle / MAX_ANGLE) * 100.0;

  return percentage;
}

void loop() {
  // Read tongue movement
  float movement = readTongueMovement();

  // Print to Serial Monitor
  Serial.print("Tongue Movement: ");
  Serial.print(movement);
  Serial.println(" %");

  // Send via BLE if connected
  if (deviceConnected) {
    String data = String(movement, 1) + "\n";
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
