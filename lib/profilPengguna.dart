import 'package:flutter/material.dart';

class ProfilPengguna extends StatefulWidget {
  const ProfilPengguna({super.key});

  @override
  State<ProfilPengguna> createState() => _ProfilPenggunaState();
}

class _ProfilPenggunaState extends State<ProfilPengguna> {
  String loggedInNama = '';
  String loggedInNamapanjang = '';

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Color.fromARGB(96, 94, 220, 255),   
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 130)),
          Text("PROFIL",
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
                          backgroundImage: AssetImage("assets/profil.jpg"), //NetworkImage
                          radius: 100,
                          ), //CircleAvatar
                        ), //CircleAvatar
                        SizedBox(
                          height: 10,
                        ), //SizedBox
                        Text(
                          "Yuren",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ), //Textstyle
                        ), //Text
                        Text(
                          "Yuren Prisilla",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ), //Textstyle
                        ),
                        SizedBox(
                          height: 20,
                        ), //SizedBox
                        Text(
                          'Name                      : Yuren \nFull Name               : Yuren Prisilla\nHydroponic Name : My Hydroponic',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 26, 67, 78),
                          ), //Textstyle
                        ),
                        Padding(padding: EdgeInsets.only(top: 40)),
                        Text(
                          'Email : yuren.prisilla19@gmail.com',
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
