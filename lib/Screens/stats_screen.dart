import 'dart:developer';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:presensi_sabu_raijua/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:presensi_sabu_raijua/config/palette.dart';
import 'package:presensi_sabu_raijua/config/styles.dart';
import 'package:presensi_sabu_raijua/constants.dart';
import 'package:presensi_sabu_raijua/widgets/widgets.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Map<String, int> statusCount = {
    'pending': 0,
    'complete': 0,
    'approve': 0,
    'reject': 0
  };
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayatPekerjaan();
  }

  Future<void> fetchRiwayatPekerjaan() async {
    debugPrint("fetchRiwayatPekerjaan");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? uuid = prefs.getString("ID");

      if (uuid == null) return;

      var url = Uri.parse(Core().ApiUrl + "riwayatPekerjaan/get_riwayat");
      var response = await http.post(
          // Ubah ke POST
          url,
          body: {"pegawai_idpegawai": uuid});

      print("Response: ${response.body}"); // Untuk debugging

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == 200 && jsonResponse['data'] != null) {
          var jsonData = jsonResponse['data'] as List;

          // Filter data berdasarkan uuid
          var filteredData = jsonData
              .where((item) => item['pegawai_idpegawai'].toString() == uuid)
              .toList();

          print("Filtered Data: $filteredData"); // Untuk debugging

          // Hitung jumlah masing-masing status
          Map<String, int> tempCount = {
            'pending': 0,
            'complete': 0,
            'approve': 0,
            'reject': 0
          };

          for (var item in filteredData) {
            String status = item['status'].toString().toLowerCase();
            if (tempCount.containsKey(status)) {
              tempCount[status] = (tempCount[status] ?? 0) + 1;
            }
          }

          print("Status Count: $tempCount"); // Untuk debugging

          if (mounted) {
            setState(() {
              statusCount = tempCount;
              isLoading = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              statusCount = {
                'pending': 0,
                'complete': 0,
                'approve': 0,
                'reject': 0
              };
              isLoading = false;
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            statusCount = {
              'pending': 0,
              'complete': 0,
              'approve': 0,
              'reject': 0
            };
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching data: $e'); // Untuk debugging
      if (mounted) {
        setState(() {
          statusCount = {
            'pending': 0,
            'complete': 0,
            'approve': 0,
            'reject': 0
          };
          isLoading = false;
        });
      }
    }
  }

  Widget _buildLegendItem(String label, Color color, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$label ($value)',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticPie() {
    int total = statusCount.values.fold(0, (sum, value) => sum + value);

    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Grafik Pekerjaan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (total > 0)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: [
                            if (statusCount['pending']! > 0)
                              PieChartSectionData(
                                color: Colors.orange,
                                value: statusCount['pending']?.toDouble() ?? 0,
                                title:
                                    '${((statusCount['pending'] ?? 0) / total * 100).toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            if (statusCount['complete']! > 0)
                              PieChartSectionData(
                                color: Colors.blue,
                                value: statusCount['complete']?.toDouble() ?? 0,
                                title:
                                    '${((statusCount['complete'] ?? 0) / total * 100).toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            if (statusCount['approve']! > 0)
                              PieChartSectionData(
                                color: Colors.green,
                                value: statusCount['approve']?.toDouble() ?? 0,
                                title:
                                    '${((statusCount['approve'] ?? 0) / total * 100).toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            if (statusCount['reject']! > 0)
                              PieChartSectionData(
                                color: Colors.red,
                                value: statusCount['reject']?.toDouble() ?? 0,
                                title:
                                    '${((statusCount['reject'] ?? 0) / total * 100).toStringAsFixed(1)}%',
                                radius: 50,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLegendItem('Pending', Colors.orange,
                              statusCount['pending'] ?? 0),
                          _buildLegendItem('Complete', Colors.blue,
                              statusCount['complete'] ?? 0),
                          _buildLegendItem('Approve', Colors.green,
                              statusCount['approve'] ?? 0),
                          _buildLegendItem(
                              'Reject', Colors.red, statusCount['reject'] ?? 0),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              const Expanded(
                child: Center(
                  child: Text(
                    'Belum ada data pekerjaan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildHeader() {
    return const SliverPadding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 40.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'STATISTIK PEKERJAAN',
          style: TextStyle(
            color: CText,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CBackground,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              "assets/images/dash_tr.png",
              height: size.height * 0.4,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/images/dash_bl.png",
              height: size.height * 0.4,
              width: size.width,
              fit: BoxFit.fill,
            ),
          ),
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: <Widget>[
              _buildHeader(),
              _buildStatisticPie(),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                sliver: SliverToBoxAdapter(
                  child: StatsGrid(),
                ),
              ),
              if (isLoading)
                const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )
            ],
          ),
        ],
      ),
    );
  }
}
