// import 'package:flutter/material.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'Halaman_Suhu.dart';

// void main() {
//   final client = MqttServerClient('broker.hivemq.com', ''); // Replace with your broker's address
//   client.connect('kel6'); // Replace with a unique client ID
//   runApp(Suhuuu(client: client));
// }

// class Suhuuu extends StatelessWidget {
//   final MqttServerClient client;
//   Suhuuu({required this.client});
//   @override
//   Widget build(BuildContext context) {
//     client.subscribe('iot-hidroponik-kel6', MqttQos.atLeastOnce); // Subscribe to the weather updates topic
//     return MaterialApp(
//       title: 'Weather App',
//       home: Chartsuhu(client: client),
//     );
//   }
// }