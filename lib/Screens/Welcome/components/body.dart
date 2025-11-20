import 'package:flutter/material.dart';
//import 'package:lottie/lottie.dart';
import 'package:presensi_sabu_raijua/Screens/Welcome/components/background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1E3A8A), // Biru tua
                  Color(0xFF3B82F6), // Biru medium
                  Color(0xFFFBBF24), // Biru terang
                  Color(0xFFFBBF24), // Kuning
                ],
                stops: [0.0, 0.4, 0.7, 1.0],
              ),
            ),
            child: Stack(children: <Widget>[
              Positioned(
                  top: size.height * 0.12,
                  left: 0,
                  right: 0,
                  bottom: size.height * 0.45,
                  child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      curve: Curves.easeOutBack,
                      duration: Duration(seconds: 3),
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(120, 0, 0, 0),
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "PRESENSI ONLINE",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "KABUPATEN SABU RAIJUA",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              "assets/images/icon_saburaijua.png",
                              width: size.width * 0.5, //ukuran gambar
                            )
                          ],
                        ),
                      ),
                      builder: (context, value, child) {
                        final scale = 0.85 + (0.15 * value);
                        return Opacity(
                            opacity: value,
                            child: Transform.scale(
                              scale: scale,
                              child: child,
                            ));
                      })),
              Positioned(
                bottom: 0,
                left: 0,
                child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(seconds: 3),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      child: Image(
                        image:
                            AssetImage("assets/images/bupati_sabu_raijua.png"),
                        height: size.height * 0.3,
                      ),
                    ),
                    builder: (context, value, child) {
                      return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(-20 * (1 - value), 20 * (1 - value)),
                            child: child,
                          ));
                    }),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(seconds: 3),
                    curve: Curves.easeOutCubic,
                    child: Container(
                      child: Image(
                        image: AssetImage(
                            "assets/images/wakil_bupati_sabu_raijua.png"),
                        height: size.height * 0.3,
                      ),
                    ),
                    builder: (context, value, child) {
                      return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(20 * (1 - value), 20 * (1 - value)),
                            child: child,
                          ));
                    }),
              )
            ])));
  }
}
