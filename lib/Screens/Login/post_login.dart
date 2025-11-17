import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_presensi_kdtg/core.dart';
import 'package:http/http.dart' as http;

class PostLogin {
  int status_kode;
  String status_spesial;
  String message;
  String Pegawai;
  String NIP;
  String UUID;
  String IDKampus, NamaKampus;
  String LokasiLat, LokasiLng, Radius;
  String jab_struktur;  // Tambahkan field ini

  PostLogin(
      {this.status_kode = 0,
      this.message = "",
      this.NIP = "",
      this.Pegawai = "",
      this.UUID = "",
      this.status_spesial = "",
      this.LokasiLat = "",
      this.LokasiLng = "",
      this.Radius = "",
      this.IDKampus = "",
      this.NamaKampus = "",
      this.jab_struktur = ""});  // Tambahkan parameter ini

  factory PostLogin.createPostLogin(Map<String, dynamic> object) {
    print("Response data: ${object['response']}"); // untuk debug response
    
    return PostLogin(
      status_kode: object['message']['status'],
      message: object['message']['message'],
      IDKampus: object['message']['kampus']['idkampus'],
      NamaKampus: object['message']['kampus']['nama_kampus'],
      LokasiLat: object['message']['kampus']['latitude'],
      LokasiLng: object['message']['kampus']['longtitude'],
      Radius: object['message']['kampus']['radius'],
      NIP: object['response']["nip"],
      Pegawai: object['response']["nama"],
      UUID: object['response']["uuid"],
      status_spesial: object['response']["spesial"].toString(),
      jab_struktur: object['response']["jab_struktur"] ?? "",  // Tambahkan ini
    );
  }

  static Future<PostLogin?> connectToApi(
      String username, String password, String token) async {
    var url = Uri.parse(Core().ApiUrl + "Login/aksi_login");
    var apiResult = await http.post(url, body: {
      "nip": username,
      "password": password,
      "token": token,
    });
    
    print("API Response: ${apiResult.body}"); // untuk debug response API
    
    if (apiResult.statusCode == 200) {
      var jsonObject = json.decode(apiResult.body);
      return PostLogin.createPostLogin(jsonObject);
    } else {
      return null;
    }
  }
}
