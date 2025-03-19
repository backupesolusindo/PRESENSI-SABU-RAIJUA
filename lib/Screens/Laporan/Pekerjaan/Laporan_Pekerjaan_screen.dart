import 'package:flutter/material.dart';
import 'package:mobile_presensi_kdtg/Screens/Laporan/Pekerjaan/components/body.dart';

class LaporanPekerjaanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Laporan Pekerjaan",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
