import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/constants.dart';

class DaftarPekerjaanBottomSheet extends StatelessWidget {
  final List dataPekerjaan;
  final Future<void> Function(Map) onAddPekerjaan;

  const DaftarPekerjaanBottomSheet({
    Key? key,
    required this.dataPekerjaan,
    required this.onAddPekerjaan,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Text(
                  'Daftar Pekerjaan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(15),
              itemCount: dataPekerjaan.length,
              itemBuilder: (context, index) {
                var pekerjaan = dataPekerjaan[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      pekerjaan['nama_pekerjaan'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            SizedBox(width: 5),
                            Text("Point: ${pekerjaan['point']}"),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.category, size: 16, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(
                              "Tipe: ${pekerjaan['tipe_pekerjaan'] == '0' ? 'Fleksibel' : 'Harian'}",
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        color: kPrimaryColor,
                        size: 35,
                      ),
                      onPressed: () async {
                        await _showAddConfirmation(context, pekerjaan);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddConfirmation(BuildContext context, Map pekerjaan) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Tambah Pekerjaan",
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
                "Apakah Anda ingin menambahkan pekerjaan berikut:",
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
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Tambah"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (result == true) {
      Navigator.pop(context); // Tutup bottom sheet
      try {
        await onAddPekerjaan(pekerjaan);
      } catch (e) {
        print("Error adding pekerjaan: $e");
      }
    }
  }
}
