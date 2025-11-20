import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/Screens/JadwalWF/components/body.dart';

class JadwalWFScreenn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jadwal WFH dan WFO Pegawai",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
