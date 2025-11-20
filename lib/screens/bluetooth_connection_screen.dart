import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/bluetooth_service.dart';
import 'home_screen.dart';

class BluetoothConnectionScreen extends StatefulWidget {
  const BluetoothConnectionScreen({super.key});

  @override
  State<BluetoothConnectionScreen> createState() =>
      _BluetoothConnectionScreenState();
}

class _BluetoothConnectionScreenState extends State<BluetoothConnectionScreen> {
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    // Auto-start scanning when screen opens
    Future.delayed(const Duration(milliseconds: 500), () {
      _startScanning();
    });
  }

  Future<void> _startScanning() async {
    setState(() => _isScanning = true);
    final bluetoothService = context.read<BluetoothManager>();
    await bluetoothService.startScanning();
    setState(() => _isScanning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryBlue,
              AppConstants.accentBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bluetooth,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Connect ESP32 Sensors',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Searching for devices...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              // Device Status Cards
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<BluetoothManager>(
                    builder: (context, bluetooth, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _DeviceCard(
                              title: 'Flow Rate Sensor',
                              deviceName: 'FlowRate_ESP32',
                              isConnected: bluetooth.flowRateDevice != null,
                              icon: Icons.air,
                            ),
                            const SizedBox(height: 16),
                            _DeviceCard(
                              title: 'Bite Force Sensor',
                              deviceName: 'BiteForce_ESP32',
                              isConnected: bluetooth.biteForceDevice != null,
                              icon: Icons.fitness_center,
                            ),
                            const SizedBox(height: 16),
                            _DeviceCard(
                              title: 'Tongue Movement Sensor',
                              deviceName: 'Tongue_ESP32',
                              isConnected: bluetooth.tongueDevice != null,
                              icon: Icons.accessibility_new,
                            ),
                            const SizedBox(height: 32),
                            // Scan Button
                            if (!_isScanning)
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: ElevatedButton.icon(
                                  onPressed: _startScanning,
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Scan Again'),
                                ),
                              )
                            else
                              const Center(
                                child: CircularProgressIndicator(),
                              ),
                            const SizedBox(height: 16),
                            // Continue Button (enabled when at least one device is connected)
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: ElevatedButton(
                                onPressed: bluetooth.flowRateDevice != null ||
                                        bluetooth.biteForceDevice != null ||
                                        bluetooth.tongueDevice != null
                                    ? () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomeScreen(),
                                          ),
                                        );
                                      }
                                    : null,
                                child: const Text('Continue'),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Skip (Use without sensors)',
                                style: TextStyle(
                                  color: AppConstants.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Instructions
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: AppConstants.primaryBlue,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Troubleshooting',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    '• Make sure ESP32 devices are powered on\n'
                                    '• Enable Bluetooth on your phone\n'
                                    '• Grant location permissions\n'
                                    '• Keep devices within 10 meters\n'
                                    '• Restart ESP32 if not detected',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String title;
  final String deviceName;
  final bool isConnected;
  final IconData icon;

  const _DeviceCard({
    required this.title,
    required this.deviceName,
    required this.isConnected,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected ? Colors.green : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isConnected
                  ? Colors.green.shade100
                  : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isConnected ? Colors.green.shade700 : Colors.grey,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  deviceName,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            isConnected ? Icons.check_circle : Icons.search,
            color: isConnected ? Colors.green : Colors.grey,
            size: 32,
          ),
        ],
      ),
    );
  }
}
