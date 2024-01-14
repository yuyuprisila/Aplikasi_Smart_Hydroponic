import 'package:flutter/material.dart';
import 'package:Hydroponic/halaman_login.dart';
import 'package:Hydroponic/header_drawer.dart';
import 'package:Hydroponic/info.dart';
import 'package:Hydroponic/Halaman_KualitasAir.dart';
import 'package:Hydroponic/Halaman_Aliran.dart';
import 'package:Hydroponic/Halaman_Suhu.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
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
    } else if (flowRate == 'N/A') {
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



  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Color> colors = [
    const Color.fromARGB(255, 229, 222, 246),
    const Color.fromARGB(255, 250, 243, 235),
    const Color.fromARGB(255, 235, 250, 239),
  ];

  final List<IconData> iconns = [
    Icons.device_thermostat,
    Icons.opacity,
    Icons.water_drop,
  ];
// Navigator.push(context, MaterialPageRoute(builder: (context)=>const Chart()));
  final List<Widget> link = [
    Chartsuhu(),
    ChartkualitasA(),
    AliranAir(),
    // Mqttnyoba()
  ];

  final List<String> teks = [
    "Suhu",
    "Kualitas Air",
    "Aliran Air",
  ];

  final List<String> keterangan = [
    "Monitoring Suhu",
    "Monitoring Kualitas Air",
    "Penambahan Cahaya",
  ];

  final List<IconData> iconnsprediction = [
    Icons.air,
    Icons.water,
    Icons.wb_sunny,
  ];

  final List<String> jam = [
    "15:00",
    "15:00",
    "15.00",
  ];
  
  List<String> derajat = [];

  @override
  Widget build(BuildContext context){
    derajat = [
      '$temperature °C',
      updatestring(int.tryParse(turbidity) ?? 0),
      "$flowRate",
    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 26, 67, 78),
        elevation: 0.0,
        toolbarHeight: 100,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.menu,
              size: 35,
              
            ),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        )
      ),
      drawer: Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: 250, // Lebar drawer
          height: 500, // Tinggi drawer
          margin: EdgeInsets.only(left: 10, top: 30),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20),
            ),
            child: ListView(
              padding: EdgeInsets.all(0),
              children: <Widget>[
                MyHeaderDrawer(),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("Info"),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => infoapp()), // Ganti 'HalamanTujuan' dengan nama halaman tujuan Anda
                    );  
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()), // Ganti 'HalamanTujuan' dengan nama halaman tujuan Anda
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 26, 67, 78),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Hydroponic Plants', 
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  
                ),
                ),
            ),
            Container(
              padding: EdgeInsets.only(left: 30, right: 30, top: 10),
              child: Text(
                'Monitoring kualitas suhu, keadaan Air tanaman hidroponik', 
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Arial',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                  height: 2
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0), 
                  topRight: Radius.circular(40.0), 
                ),
                color: Colors.white, 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0.0, -1.0), // Posisi bayangan (x, y)
                    blurRadius: 28.0, // Radius blur
                  )
                ]
              ),
              width: double.infinity,
              height: 500,
              padding: EdgeInsets.only(top: 40, left: 30, right: 30),
              child: ListView(
                children: [
                  Row(
                    children: [
                      Text(
                        'Controls',
                        style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          // letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 10),),
                  Container(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index){
                        Color color = colors[index % colors.length];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context)=>link[index]
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: color,
                              ),
                              height: 140,
                              width: 140,
                              child: Center(
                                child: 
                                ListView(
                                  children: [
                                    Padding(padding: EdgeInsets.only(top: 20,)),
                                    Container(
                                      margin: EdgeInsets.only(left: 15),
                                      height: 45.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 45.0,
                                            width: 45.0,
                                            decoration: BoxDecoration(
                                              color: Colors.white, // Warna latar belakang ikon
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                // Icons.home, 
                                                iconns[index],
                                                color: const Color.fromARGB(255, 26, 67, 78), // Warna ikon
                                                size: 30, // Ukuran ikon
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 30, )),
                                    Container(
                                      margin: EdgeInsets.only(left: 17),
                                      child: Text(
                                        teks[index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Arial',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 8)),
                                    Container(
                                      margin: EdgeInsets.only(left: 17, right: 17,),
                                      child: Text(
                                        keterangan[index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Arial',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15),),
                  Text(
                    'Prediction',
                    style: TextStyle(
                      color: Color.fromARGB(255, 128, 128, 128),
                      fontFamily: 'Arial',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10,),
                    child: Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: 3,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              // color: Colors.blue,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color.fromARGB(255, 26, 67, 78),
                                        border: Border.all(width: 1)
                                      ),
                                      height: 50,
                                      width: 50,
                                      child: Icon(
                                        iconnsprediction[index],
                                        color:Colors.white, 
                                        size: 30, 
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    // color: Colors.black,
                                    width: 170,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 25,
                                          child: Text(teks[index], style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Arial',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),),
                                        ),
                                        Container(
                                          width: 200,
                                          child: Text('Hari Ini', style: TextStyle(
                                            color: const Color.fromARGB(255, 55, 55, 55),
                                              fontFamily: 'Arial',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                          ),),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    // color: Colors.blue,
                                    child: Column(
                                      children: [
                                        Container(
                                          // width: 50,
                                          // color: Colors.lightBlue,
                                          child: Text(jam[index])
                                        ),
                                        Center(
                                          child: Container(
                                            // width: 50,
                                            height: 34,
                                            // color: Colors.blueGrey,
                                            child: Text(derajat[index], style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),)
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }
}