import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class AliranAir extends StatefulWidget {
  const AliranAir({super.key});

  @override
  State<AliranAir> createState() => _AliranAirState();
}

class _AliranAirState extends State<AliranAir> {
  late MqttServerClient client;
  String temperature = 'N/A';
  String turbidity = 'N/A';
  String flowRate = 'N/A';
  
  @override
  void initState() {
    super.initState();
    connectMQTT();
  }

  void connectMQTT() async {
    client = MqttServerClient.withPort('broker.hivemq.com', 'kel6', 1883);

    client.onDisconnected = onDisconnected;

    final connMess = MqttConnectMessage()
        .withClientIdentifier('kel6') // Ganti dengan identifier klien yang unik
        .keepAliveFor(60) // Tingkatkan jika diperlukan
        .startClean() // Hapus sesi sebelumnya
        .withWillTopic('willtopic') // Topik pesan akan
        .withWillMessage('Will message') // Pesan akan
        .authenticateAs('username', 'password'); // Ganti dengan informasi otentikasi jika diperlukan;

    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('Client connected');
      subscribeToTopic('iot-hidroponik-kel6'); // Ganti dengan topik yang sesuai
    } else {
      print('Client connection failed - disconnecting, state is ${client.connectionStatus?.state}');
      client.disconnect();
    }
  }

  void subscribeToTopic(String topic) {
    if (client != null && client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atMostOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        if (c.isNotEmpty) {
          final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
          final String pt =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          print('GOT A MESSAGE $pt');
          processMessage(pt);
        }
      });
      print('Subscribed to topic: $topic');
    } else {
      print('Client not connected');
    }
  }

  void processMessage(String message) {
    print('Menerima pesan MQTT: $message');

    // Proses dan parsing pesan MQTT di sini
    // Misalnya, jika pesan memiliki format "Temperature: 27.00 ÂºC, Turbidity: 51571.19 NTU, Aliran : 0.00 L/menit"
    List<String> parts = message.split(', ');

    for (String part in parts) {
      if (part.startsWith('Temperature:')) {
        temperature = part.split(' ')[1];
      } else if (part.startsWith('Turbidity:')) {
        turbidity = part.split(' ')[1];
        // updatestring(int.tryParse(turbidity) ?? 0);
      } else if (part.startsWith('Aliran :')) {
        flowRate = part.split(' ')[2];
      }
    }

    // Cetak untuk debugging
    print('Suhu yang diperbarui: $temperature');
    print('Turbidity yang diperbarui: $turbidity');
    print('Aliran yang diperbarui: $flowRate');

    // Jika tidak ada bagian yang sesuai, tetapkan nilai default
    if (temperature == 'N/A') {
      temperature = 'Default'; // Ganti dengan nilai default yang sesuai
    } else if (turbidity == 'N/A') {
      turbidity = 'Default'; // Ganti dengan nilai default yang sesuai
    } else if (flowRate == 'Tidak Ada') {
      flowRate = 'Default'; // Ganti dengan nilai default yang sesuai
    }

    setState(() {});
  }



  void onConnected() {
    print('Connected');
  }

  void onDisconnected() {
    print('Disconnected');
  }

  void onSubscribeFail(String topic) {
    print('Failed to subscribe to $topic');
  }


  String updatestring(int turbiiiiii) {

    print("bisa");
    String kesturbidity = "";
    int turbidityValue = turbiiiiii;

    // Tentukan kondisi dan set variabel kesturbidity
    if (turbidityValue > 60000) {
      kesturbidity = "Bersih";
    } else {
      kesturbidity = "Tidak Bersih";
    }
    return kesturbidity;
  }
  String updatestringflow(int floww) {

    print("bisatuh");
    String kesflowrate = "";
    int flowrateValue = floww;

    // Tentukan kondisi dan set variabel kesflowrate
    if (flowrateValue > 0) {
      kesflowrate = "Ada Aliran";
    } else {
      kesflowrate = "Tidak Ada Aliran";
    }
    return kesflowrate;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 26, 67, 78),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Water Info",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Arial',
            fontSize: 25,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        // flexibleSpace: Image(
        //   image: AssetImage('assets/watering.png'), // Ganti dengan path gambar Anda
        //   fit: BoxFit.cover,
        // ),
        // elevation: 0.0,
        toolbarHeight: 70,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/watering.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0, 
            right: 0,
            child: SizedBox(
              height: 100,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  primary: Colors.orange, // Warna latar belakang tombol
                  onPrimary: Colors.white, // Warna teks tombol (saat tombol tidak aktif)
                  fixedSize: Size(120, 50),
                ),
                onPressed: () {},
                child: Text(updatestringflow(int.tryParse(flowRate) ?? 0), style: TextStyle(fontSize: 20),),
              ),
            ),
          ),
          Positioned(
            top: 130,
            left: 220,
            child: Text(
              '  Aliran Air\n $flowRate L/menit', 
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                height: 1.5,
              ),
            ),
          ),
          Positioned(
            top: 230,
            left: 150,
            child: Text(
              'Memantau Aliran air \n    pada tanaman', 
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arial',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                height: 1.5
              ),
            ),
          )
        ],
      ),
    );
  }
}