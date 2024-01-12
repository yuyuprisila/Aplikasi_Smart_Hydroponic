import 'package:flutter/material.dart';
import 'package:pemrograman_mobile/halaman_login.dart';

class halAwalState extends StatefulWidget {
  const halAwalState({super.key});

  @override
  State<halAwalState> createState() => _halAwalStateState();
}

class _halAwalStateState extends State<halAwalState> {
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
                "Taking care of your plant",
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
                "Monitor the growth of your hydroponic plants in real-time with the Smart Hydroponic app, ensuring optimal health and productivity.",
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
              GestureDetector(
                onTap: () {
                  // Arahkan ke halaman selanjutnya ketika teks diklik
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                child: Text(
                  "Get started",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                "....    .............  .",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Color.fromARGB(255,195, 244, 77),
                    decorationThickness: 6.0,
                ),
              )
            ],
          ),
      )
    );
  }
}