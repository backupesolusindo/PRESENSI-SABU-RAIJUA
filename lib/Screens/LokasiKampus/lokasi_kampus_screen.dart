import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/Screens/LokasiKampus/components/body.dart';

class LokasiKampusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Lokasi Kampus",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
