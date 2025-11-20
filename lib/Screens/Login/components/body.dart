import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:presensi_sabu_raijua/Screens/Absen/absen_screen.dart';
import 'package:presensi_sabu_raijua/Screens/Login/post_login.dart';
import 'package:presensi_sabu_raijua/Screens/dashboard_screen.dart';
import 'package:presensi_sabu_raijua/Screens/screens.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensi_sabu_raijua/services/location_services.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> with SingleTickerProviderStateMixin {
  PostLogin postLogin = new PostLogin();
  String pesan = "";
  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  String token = "123";
  int statusLoading = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    cekFakeGPS();
    getToken();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutCubic));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  cekFakeGPS() async {
    bool _isMockLocation = await LocationService.isMockLocation;
    print("fake GPS :");
    print(_isMockLocation);
  }

  void getToken() async {
    token = (await FirebaseMessaging.instance.getToken())!;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
              Color(0xFFFBBF24),
            ],
            stops: [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.08),

                      // Title
                      Text(
                        "LOGIN",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        "E-PRESENSI",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),

                      // Logo
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/icon_saburaijua.png",
                          width: size.width * 0.35,
                        ),
                      ),

                      SizedBox(height: size.height * 0.05),
                      Container(
                        padding: EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Color(0xFF1E40AF).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Username Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: txtUsername,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: "NIP / NIK atau SSO Email",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Color(0xFF3B82F6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Password Field
                            // Password Field
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: txtPassword,
                                obscureText: _obscurePassword,
                                style: TextStyle(fontSize: 16),
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFF3B82F6),
                                  ),

                                  // 👁️ icon show/hide password
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),

                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 12),

                            SizedBox(height: 8),

                            // Error Message
                            if (pesan.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 16),
                                child: Text(
                                  pesan,
                                  style: TextStyle(
                                    color: statusLoading == 1
                                        ? Color(0xFFFBBF24)
                                        : Colors.red[300],
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                            // Login Button
                            if (statusLoading == 1)
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFBBF24),
                                      Color(0xFFF59E0B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            if (statusLoading == 0)
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFBBF24),
                                      Color(0xFFF59E0B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFFBBF24).withOpacity(0.5),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () async {
                                      setState(() {
                                        pesan = "Tunggu Sedang Proses";
                                        statusLoading = 1;
                                      });
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      print("Login");
                                      token = "1231";
                                      prefs.setString("token", token);
                                      PostLogin.connectToApi(txtUsername.text,
                                              txtPassword.text, token)
                                          .then((value) {
                                        setState(() {
                                          pesan = value!.message;
                                          statusLoading = 0;
                                        });
                                        if (value!.status_kode == 200) {
                                          prefs.setBool("status_login", true);
                                          prefs.setBool(
                                              "sl_harian_masuk", true);
                                          prefs.setBool(
                                              "sl_harian_pulang", true);
                                          prefs.setBool(
                                              "sl_istirahat_keluar", true);
                                          prefs.setBool(
                                              "sl_istirahat_masuk", true);
                                          prefs.setBool("sl_wfh_mulai", true);
                                          prefs.setBool("sl_wfh_selesai", true);
                                          prefs.setBool("sl_lokasi", true);
                                          prefs.setBool("sl_kegiatan", true);
                                          prefs.setBool("status_lokasi", true);
                                          prefs.setString("ID", value.UUID);
                                          prefs.setString("NIP", value.NIP);
                                          prefs.setString(
                                              "Nama", value.Pegawai);
                                          prefs.setString(
                                              "idKampus", value.IDKampus);
                                          prefs.setString(
                                              "Lokasi", value.NamaKampus);
                                          prefs.setString("jab_struktur",
                                              value.jab_struktur);
                                          prefs.setDouble("LokasiLat",
                                              double.parse(value.LokasiLat));
                                          prefs.setDouble("LokasiLng",
                                              double.parse(value.LokasiLng));
                                          prefs.setDouble("Radius",
                                              double.parse(value.Radius));
                                          prefs.setInt("status_spesial",
                                              int.parse(value.status_spesial));
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: DashboardScreen()));
                                        }
                                      });
                                    },
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            SizedBox(height: 20),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
