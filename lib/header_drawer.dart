import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget{
  const MyHeaderDrawer({super.key});

  @override
  _MyHeaderDrawerState createState()=> _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer>{
  @override
  Widget build(BuildContext context){
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 26, 67, 78),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            height: 100.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/profil.jpg')
              )
            ),
          ),
          const Text('Yuren', style: TextStyle(color: Colors.white, fontSize: 20),),
          const Text("Yuren Prisilla", style: TextStyle(color: Colors.white, fontSize: 14),)
        ],
      ),
    );
  }
}