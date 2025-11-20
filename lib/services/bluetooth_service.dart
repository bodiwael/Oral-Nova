import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants/app_constants.dart';

enum SensorType { flowRate, biteForce, tongue }

class BluetoothService extends ChangeNotifier {
  BluetoothDevice? flowRateDevice;
  BluetoothDevice? biteForceDevice;
  BluetoothDevice? tongueDevice;

  BluetoothCharacteristic? flowRateCharacteristic;
  BluetoothCharacteristic? biteForceCharacteristic;
  BluetoothCharacteristic? tongueCharacteristic;

  double currentFlowRateInhale = 0.0;
  double currentFlowRateExhale = 0.0;
  double currentBiteForce = 0.0;
  double currentTongueMovement = 0.0;

  bool isScanning = false;
  bool isConnected = false;

  StreamSubscription? _flowRateSubscription;
  StreamSubscription? _biteForceSubscription;
  StreamSubscription? _tongueSubscription;

  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  Future<void> startScanning() async {
    bool hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      debugPrint('Bluetooth permissions not granted');
      return;
    }

    isScanning = true;
    notifyListeners();

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          String deviceName = result.device.platformName;

          // Identify devices by name (update these to match your ESP32 names)
          if (deviceName.contains('FlowRate') && flowRateDevice == null) {
            flowRateDevice = result.device;
            connectToDevice(SensorType.flowRate);
          } else if (deviceName.contains('BiteForce') && biteForceDevice == null) {
            biteForceDevice = result.device;
            connectToDevice(SensorType.biteForce);
          } else if (deviceName.contains('Tongue') && tongueDevice == null) {
            tongueDevice = result.device;
            connectToDevice(SensorType.tongue);
          }
        }
      });
    } catch (e) {
      debugPrint('Error scanning: $e');
    }

    isScanning = false;
    notifyListeners();
  }

  Future<void> connectToDevice(SensorType type) async {
    BluetoothDevice? device;

    switch (type) {
      case SensorType.flowRate:
        device = flowRateDevice;
        break;
      case SensorType.biteForce:
        device = biteForceDevice;
        break;
      case SensorType.tongue:
        device = tongueDevice;
        break;
    }

    if (device == null) return;

    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();

      for (BluetoothService service in services) {
        if (type == SensorType.flowRate &&
            service.uuid.toString() == AppConstants.flowRateServiceUUID) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid.toString() == AppConstants.flowRateCharUUID) {
              flowRateCharacteristic = char;
              await char.setNotifyValue(true);
              _flowRateSubscription = char.lastValueStream.listen((value) {
                _parseFlowRateData(value);
              });
            }
          }
        } else if (type == SensorType.biteForce &&
            service.uuid.toString() == AppConstants.biteForceServiceUUID) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid.toString() == AppConstants.biteForceCharUUID) {
              biteForceCharacteristic = char;
              await char.setNotifyValue(true);
              _biteForceSubscription = char.lastValueStream.listen((value) {
                _parseBiteForceData(value);
              });
            }
          }
        } else if (type == SensorType.tongue &&
            service.uuid.toString() == AppConstants.tongueServiceUUID) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid.toString() == AppConstants.tongueCharUUID) {
              tongueCharacteristic = char;
              await char.setNotifyValue(true);
              _tongueSubscription = char.lastValueStream.listen((value) {
                _parseTongueData(value);
              });
            }
          }
        }
      }

      isConnected = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error connecting to device: $e');
    }
  }

  void _parseFlowRateData(List<int> data) {
    // Parse the data format: "Inhale,Exhale\n"
    String dataString = String.fromCharCodes(data).trim();
    List<String> values = dataString.split(',');

    if (values.length == 2) {
      currentFlowRateInhale = double.tryParse(values[0]) ?? 0.0;
      currentFlowRateExhale = double.tryParse(values[1]) ?? 0.0;
      notifyListeners();
    }
  }

  void _parseBiteForceData(List<int> data) {
    // Parse bite force data (format depends on your ESP32 implementation)
    String dataString = String.fromCharCodes(data).trim();
    currentBiteForce = double.tryParse(dataString) ?? 0.0;
    notifyListeners();
  }

  void _parseTongueData(List<int> data) {
    // Parse tongue movement data from flex sensor
    String dataString = String.fromCharCodes(data).trim();
    currentTongueMovement = double.tryParse(dataString) ?? 0.0;
    notifyListeners();
  }

  double getCurrentReading(SensorType type) {
    switch (type) {
      case SensorType.flowRate:
        // Return combined flow rate or average
        return (currentFlowRateInhale + currentFlowRateExhale) / 2;
      case SensorType.biteForce:
        return currentBiteForce;
      case SensorType.tongue:
        return currentTongueMovement;
    }
  }

  Future<void> disconnect() async {
    await _flowRateSubscription?.cancel();
    await _biteForceSubscription?.cancel();
    await _tongueSubscription?.cancel();

    await flowRateDevice?.disconnect();
    await biteForceDevice?.disconnect();
    await tongueDevice?.disconnect();

    flowRateDevice = null;
    biteForceDevice = null;
    tongueDevice = null;

    isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
