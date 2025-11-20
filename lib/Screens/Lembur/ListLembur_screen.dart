import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/Screens/Lembur/components/body.dart';

class ListLemburScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Jadwal Lembur",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ),
      body: Body(),
    );
  }
}
