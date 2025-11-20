import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/Screens/Laporan/Pekerjaan/components/background.dart';
import 'package:presensi_sabu_raijua/components/flat_date_field.dart';
import 'package:presensi_sabu_raijua/constants.dart';
import 'package:presensi_sabu_raijua/core.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  List riwayatPekerjaan = [];
  List dataPekerjaan = [];
  bool isLoading = false;
  String statusFilter = "";
  final txtTanggalMulai = TextEditingController();
  final txtTanggalAkhir = TextEditingController();

  @override
  void initState() {
    super.initState();
    txtTanggalMulai.text = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    txtTanggalAkhir.text = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
    fetchData();
  }

  // Fungsi untuk menghitung durasi pengerjaan
  String calculateDuration(String createdAt, String? updatedAt) {
    if (updatedAt == null || updatedAt == "null" || updatedAt.isEmpty) {
      return "Belum selesai";
    }

    DateTime startTime = DateTime.parse(createdAt);
    DateTime endTime = DateTime.parse(updatedAt);
    Duration duration = endTime.difference(startTime);

    if (duration.inDays > 0) {
      return "${duration.inDays} hari ${duration.inHours % 24} jam";
    } else if (duration.inHours > 0) {
      return "${duration.inHours} jam ${duration.inMinutes % 60} menit";
    } else {
      return "${duration.inMinutes} menit";
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String uuid = prefs.getString("ID") ?? "";

      // Fetch pekerjaan data
      var urlPekerjaan = Uri.parse(Core().ApiUrl + "Pekerjaan/get_pekerjaan");
      var responsePekerjaan = await http.get(urlPekerjaan);
      if (responsePekerjaan.statusCode == 200) {
        var dataPekerjaanJson = json.decode(responsePekerjaan.body);
        dataPekerjaan = dataPekerjaanJson['data'];
      }

      // Fetch riwayat
      var url = Uri.parse(Core().ApiUrl + "riwayatPekerjaan/get_riwayat");
      var response = await http.post(url, body: {
        "pegawai_idpegawai": uuid,
      });

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        var filteredData = jsonResponse['data']
            .where((item) => item['pegawai_idpegawai'] == uuid)
            .toList();

        // Filter berdasarkan status
        if (statusFilter.isNotEmpty) {
          filteredData = filteredData
              .where((item) => item['status'] == statusFilter)
              .toList();
        }

        setState(() {
          riwayatPekerjaan = filteredData;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  String getNamaPekerjaan(String idPekerjaan) {
    var pekerjaan = dataPekerjaan.firstWhere(
      (element) => element['id_pekerjaan'].toString() == idPekerjaan,
      orElse: () => null,
    );
    return pekerjaan != null
        ? pekerjaan['nama_pekerjaan']
        : 'Pekerjaan tidak ditemukan';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      filter: Container(
        child: Column(
          children: <Widget>[
            // Date Filter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatDateField(
                  width: size.width * 0.37,
                  hintText: "Tanggal Awal",
                  IdCon: txtTanggalMulai,
                ),
                FlatDateField(
                  width: size.width * 0.37,
                  hintText: "Tanggal Akhir",
                  IdCon: txtTanggalAkhir,
                ),
                Container(
                  margin: EdgeInsets.only(top: 12, right: 6),
                  width: size.width * 0.15,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                    onPressed: fetchData,
                    child: Icon(Icons.filter_alt_rounded, color: kPrimaryColor),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),

            // Status Filter
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusFilter.isEmpty
                            ? kPrimaryColor
                            : kPrimaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          statusFilter = "";
                          fetchData();
                        });
                      },
                      child: Text(
                        "Semua",
                        style: TextStyle(
                          color: statusFilter.isEmpty
                              ? Colors.white
                              : kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusFilter == "pending"
                            ? Colors.orange
                            : kPrimaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          statusFilter = "pending";
                          fetchData();
                        });
                      },
                      child: Text(
                        "Pending",
                        style: TextStyle(
                          color: statusFilter == "pending"
                              ? Colors.white
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusFilter == "complete"
                            ? Colors.blue
                            : kPrimaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          statusFilter = "complete";
                          fetchData();
                        });
                      },
                      child: Text(
                        "Complete",
                        style: TextStyle(
                          color: statusFilter == "complete"
                              ? Colors.white
                              : Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusFilter == "approve"
                            ? Colors.green
                            : kPrimaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          statusFilter = "approve";
                          fetchData();
                        });
                      },
                      child: Text(
                        "Approve",
                        style: TextStyle(
                          color: statusFilter == "approve"
                              ? Colors.white
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: statusFilter == "reject"
                            ? Colors.red
                            : kPrimaryLightColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          statusFilter = "reject";
                          fetchData();
                        });
                      },
                      child: Text(
                        "Reject",
                        style: TextStyle(
                          color: statusFilter == "reject"
                              ? Colors.white
                              : Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      child: Expanded(
        child: getBody(),
      ),
    );
  }

  Widget getBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        ),
      );
    }

    if (riwayatPekerjaan.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/ilustrasi/laporan_kegiatan.png",
              width: MediaQuery.of(context).size.width * 0.8,
            ),
            Text(
              "Tidak ada data pekerjaan",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: riwayatPekerjaan.length,
      itemBuilder: (context, index) {
        return getCard(riwayatPekerjaan[index]);
      },
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'complete':
        return Colors.blue;
      case 'approve':
        return Colors.green;
      case 'reject':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget getCard(item) {
    String namaPekerjaan = getNamaPekerjaan(item['pekerjaan_idpekerjaan']);
    Color statusColor = getStatusColor(item['status']);
    String duration = calculateDuration(item['created_at'], item['updated_at']);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    namaPekerjaan,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item['status'].toLowerCase() == 'approve'
                            ? Icons.check_circle
                            : item['status'].toLowerCase() == 'reject'
                                ? Icons.cancel
                                : item['status'].toLowerCase() == 'complete'
                                    ? Icons.done_all
                                    : Icons.pending,
                        size: 16,
                        color: statusColor,
                      ),
                      SizedBox(width: 4),
                      Text(
                        item['status'].toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.format_list_numbered, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Jumlah: ${item['jumlah']}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Waktu Pengerjaan: $duration",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  "Mulai: ${formatDate(DateTime.parse(item['created_at']), [
                        dd,
                        '-',
                        mm,
                        '-',
                        yyyy,
                        ' ',
                        HH,
                        ':',
                        nn
                      ])}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            if (item['updated_at'] != null && item['updated_at'] != "null") ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 16, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "Selesai: ${formatDate(DateTime.parse(item['updated_at']), [
                          dd,
                          '-',
                          mm,
                          '-',
                          yyyy,
                          ' ',
                          HH,
                          ':',
                          nn
                        ])}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
