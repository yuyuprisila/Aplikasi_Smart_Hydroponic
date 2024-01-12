import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/navigationbar.dart';
import 'package:pemrograman_mobile/profilDeveloper.dart';

class infoapp extends StatefulWidget {
  const infoapp({super.key});

  @override
  State<infoapp> createState() => _infoappState();
}

class _infoappState extends State<infoapp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/loginregister.jpeg"),
            //   // image :NetworkImage('https://i.pinimg.com/564x/7b/b8/a1/7bb8a1c2902ef64ebd058249a369de5e.jpg'),

            //   fit: BoxFit.cover,
              
            // ),
            color: const Color.fromARGB(255, 26, 67, 78),
          ),
          padding: EdgeInsets.only(top: 100, bottom: 50, left: 40, right: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image(
              //   image: 
              // ),
              Text(
                "Smart Hydroponic",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              Text(
                "Membantu mengontrol tumbuhan Hidroponik serta mengautomatisasi pengairan, pemantauan suhu, serta kualitas air yang di alirkan",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                  height: 2
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30)),
              Row(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => navigationbar(),
                            ),
                          );
                        },
                        child: Text(
                          "Kembali",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "....    .........  .",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255,195, 244, 77),
                            decorationThickness: 6.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 130)),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfilDev(),
                            ),
                          );
                        },
                        child: Text(
                          "Pengembang",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "....    ....................  .",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: Color.fromARGB(255,195, 244, 77),
                            decorationThickness: 6.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
      )
    );
  }
}