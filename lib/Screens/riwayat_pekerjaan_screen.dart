import 'dart:async';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:presensi_sabu_raijua/Screens/daftar_pekerjaan_screen.dart';
import 'package:presensi_sabu_raijua/constants.dart';

class RiwayatPekerjaanScreen extends StatefulWidget {
  final List riwayatPekerjaan;
  final List dataPekerjaan;
  final Future<void> Function(Map, String) onUpdateStatus;
  final Future<void> Function() onRefresh;
  final StreamController<List> streamController;
  final Future<void> Function(Map) onAddPekerjaan;

  RiwayatPekerjaanScreen({
    required this.riwayatPekerjaan,
    required this.dataPekerjaan,
    required this.onUpdateStatus,
    required this.onRefresh,
    required this.streamController,
    required this.onAddPekerjaan,
  });

  @override
  _RiwayatPekerjaanScreenState createState() => _RiwayatPekerjaanScreenState();
}

class _RiwayatPekerjaanScreenState extends State<RiwayatPekerjaanScreen> {
  Color _getStatusColor(String status) {
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

  void _showUpdateConfirmation(Map riwayat, Map pekerjaan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Konfirmasi Update Status",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pekerjaan['tipe_pekerjaan'] == "0"
                    ? "Apakah Anda yakin ingin menyelesaikan pekerjaan ini?"
                    : "Anda akan diminta memasukkan jumlah setelah ini. Lanjutkan?",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pekerjaan['nama_pekerjaan'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text("Point: ${pekerjaan['point']}"),
                    Text(
                      "Tipe: ${pekerjaan['tipe_pekerjaan'] == '0' ? 'Fleksibel' : 'Harian'}",
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Batal",
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Update"),
              onPressed: () async {
                Navigator.of(context).pop();
                await widget.onUpdateStatus(
                    riwayat, pekerjaan['tipe_pekerjaan']);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pekerjaan yang diambil'),
        backgroundColor: kPrimaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => DaftarPekerjaanBottomSheet(
              dataPekerjaan: widget.dataPekerjaan,
              onAddPekerjaan: (pekerjaan) async {
                await widget.onAddPekerjaan(pekerjaan);
                if (mounted) {
                  await widget.onRefresh(); // Refresh data setelah menambah
                }
              },
            ),
          );
        },
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add),
      ),
      body: Container(
        color: CBackground,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/dash_tr.png",
                height: MediaQuery.of(context).size.height * 0.2,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                "assets/images/dash_bl.png",
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            StreamBuilder<List>(
              stream: widget.streamController.stream,
              initialData: widget.riwayatPekerjaan,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Belum ada pekerjaan yang diambil",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                var riwayatList = snapshot.data!;

                return ListView.builder(
                  padding: EdgeInsets.all(15),
                  itemCount: riwayatList.length,
                  itemBuilder: (context, index) {
                    var riwayat = riwayatList[index];
                    var pekerjaan = widget.dataPekerjaan.firstWhere(
                      (item) =>
                          item['id_pekerjaan'].toString() ==
                          riwayat['pekerjaan_idpekerjaan'],
                      orElse: () => null,
                    );

                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(15),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                pekerjaan != null
                                    ? pekerjaan['nama_pekerjaan']
                                    : "Pekerjaan tidak ditemukan",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _getStatusColor(riwayat['status'])
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                riwayat['status'].toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(riwayat['status']),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            if (pekerjaan != null) ...[
                              Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  SizedBox(width: 5),
                                  Text(
                                    "Point: ${pekerjaan['point']}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.category,
                                      size: 16, color: Colors.blue),
                                  SizedBox(width: 5),
                                  Text(
                                    "Tipe: ${pekerjaan['tipe_pekerjaan'] == '0' ? 'Fleksibel' : 'Harian'}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.numbers,
                                    size: 16, color: Colors.green),
                                SizedBox(width: 5),
                                Text(
                                  "Jumlah: ${riwayat['jumlah']}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 16, color: Colors.purple),
                                SizedBox(width: 5),
                                Text(
                                  "Dibuat: ${formatDate(DateTime.parse(riwayat['created_at']), [
                                        dd,
                                        '/',
                                        mm,
                                        '/',
                                        yyyy,
                                        ' ',
                                        HH,
                                        ':',
                                        nn
                                      ])}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            if (riwayat['updated_at'] != null &&
                                riwayat['updated_at'] != "null") ...[
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.update,
                                      size: 16, color: Colors.orange),
                                  SizedBox(width: 5),
                                  Text(
                                    "Diupdate: ${formatDate(DateTime.parse(riwayat['updated_at']), [
                                          dd,
                                          '/',
                                          mm,
                                          '/',
                                          yyyy,
                                          ' ',
                                          HH,
                                          ':',
                                          nn
                                        ])}",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        trailing: riwayat['status'] == 'pending'
                            ? IconButton(
                                icon: Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                onPressed: () {
                                  if (pekerjaan != null) {
                                    _showUpdateConfirmation(riwayat, pekerjaan);
                                  }
                                },
                              )
                            : Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 35,
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
