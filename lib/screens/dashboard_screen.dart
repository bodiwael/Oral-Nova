import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import '../services/data_service.dart';

class DashboardScreen extends StatefulWidget {
  final Patient patient;

  const DashboardScreen({super.key, required this.patient});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPeriod = 'Yearly';

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
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const Text(
                      'Dash Board',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Patient name : ${widget.patient.name}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Date : ${DateFormat('M/d/y').format(DateTime.now())}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<DataService>(
                    builder: (context, dataService, child) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildChart(
                              title: 'Tongue',
                              data: dataService
                                  .getChartData(AppConstants.tongueName),
                            ),
                            const SizedBox(height: 32),
                            _buildChart(
                              title: 'Bite Pressure',
                              data: dataService
                                  .getChartData(AppConstants.bitePressureName),
                            ),
                            const SizedBox(height: 32),
                            _buildChart(
                              title: 'Flow Rate',
                              data: dataService
                                  .getChartData(AppConstants.flowRateName),
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

  Widget _buildChart({required String title, required Map<String, List<double>> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedPeriod,
              items: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                  .map((period) => DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedPeriod = value!);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: data.isEmpty
              ? Center(
                  child: Text(
                    'No data available',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                )
              : LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 20000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[300]!,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            if (value % 20000 == 0) {
                              return Text(
                                '${(value / 1000).toInt()}k',
                                style: const TextStyle(fontSize: 10),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 10,
                    minY: 0,
                    maxY: 100000,
                    lineBarsData: _buildLineChartData(data),
                  ),
                ),
        ),
      ],
    );
  }

  List<LineChartBarData> _buildLineChartData(Map<String, List<double>> data) {
    List<LineChartBarData> lines = [];

    data.forEach((key, values) {
      List<FlSpot> spots = [];
      for (int i = 0; i < values.length && i < 10; i++) {
        spots.add(FlSpot(i.toDouble(), values[i]));
      }

      lines.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppConstants.primaryBlue.withOpacity(0.7),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppConstants.lightBlue.withOpacity(0.3),
          ),
        ),
      );
    });

    // Default line if no data
    if (lines.isEmpty) {
      lines.add(
        LineChartBarData(
          spots: [
            const FlSpot(0, 10000),
            const FlSpot(2, 30000),
            const FlSpot(4, 50000),
            const FlSpot(6, 25000),
            const FlSpot(8, 55000),
          ],
          isCurved: true,
          color: AppConstants.primaryBlue.withOpacity(0.7),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            color: AppConstants.lightBlue.withOpacity(0.3),
          ),
        ),
      );
    }

    return lines;
  }
}
