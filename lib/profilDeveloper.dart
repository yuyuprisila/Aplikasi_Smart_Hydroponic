import 'package:flutter/material.dart';

class ProfilDev extends StatefulWidget {
  const ProfilDev({super.key});

  @override
  State<ProfilDev> createState() => _ProfilDevState();
}

class _ProfilDevState extends State<ProfilDev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color.fromARGB(96, 94, 220, 255),),
      backgroundColor: Color.fromARGB(96, 94, 220, 255),   
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 80)),
          Text(" HALAMAN PENGEMBANG",
          style: TextStyle(
                color: const Color.fromARGB(255, 26, 67, 78),
                fontFamily: 'Arial',
                fontSize: 25,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
          ),
          Center(
            child: Card(
                elevation: 100,
                shadowColor: Colors.black,
                color: Color.fromARGB(255, 92, 148, 163),
                child: SizedBox(
                  width: 300,
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 26, 67, 78),
                          radius: 108,
                          child: CircleAvatar( 
                          backgroundImage: AssetImage("assets/dev.jpeg"), //NetworkImage
                          radius: 100,
                          ), //CircleAvatar
                        ), //CircleAvatar
                        SizedBox(
                          height: 10,
                        ), //SizedBox
                        Text(
                          'Designer',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ), //Textstyle
                        ), //Text
                        SizedBox(
                          height: 20,
                        ), //SizedBox
                        Text(
                          'Hai, saya Yuren. Selamat datang di portal pengembang kami, tempat Anda dapat menemukan sumber daya penting untuk mengembangkan aplikasi Anda',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 26, 67, 78),
                          ), //Textstyle
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Text(
                          'Email : yuren.prisilla@mhs.ienas.ac.id',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 26, 67, 78),
                          ), //Textstyle
                        ),
                      ],
                    ), //Column
                  ), //Padding
                ), //SizedBox
              ),
          ),
        ],
      ), 
    );
  }
}