import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter/services.dart';

class informbetta extends StatefulWidget {
  const informbetta({super.key, required this.textbetta});

  final String textbetta;

  @override
  State<informbetta> createState() => _informbettaState();
}

class _informbettaState extends State<informbetta> {

  List<dynamic> bettaList = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString("assets/bettadata.json");
    final data = await json.decode(response);

    setState(() {
      bettaList = data['betta'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readJson();
  }

  var chbetta = ["ปลากัดลายผีเสื้อ","ปลากัดจีน","ปลากัดหางมงกุฎ","ปลากัดสองหาง่","ปลากัดหูช้าง","ปลากัดฮาล์ฟมูน","ปลากัดลายหินอ่อน","ปลากัดลูกหม้อ","ปลากัดป่า","ปลากัดทันโจ"];
  List<int> numbetta = [1,2,3,4,5,6,7,8,9,10];

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.indigoAccent,
          title: Text('ข้อมูลเพิ่มเติมเกี่ยวกับ ${widget.textbetta}',style: TextStyle(fontSize: 20 ,fontWeight: FontWeight.bold,fontFamily: 'DM Academy'))
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg2.jpg"),
              fit: BoxFit.fill,
            ),
          ),
        child: ListView.builder(
            padding: EdgeInsets.all(20),
            itemCount: 1,
            itemBuilder: (context, index) {
              for (var i = 0; i < 10; i++) {
                if (widget.textbetta == chbetta[i]){
                  index = numbetta[i];
                }
              }
              print(index);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(bettaList[index]["img"]),
                      radius: 80,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'ชื่อปลา: ${bettaList[index]["namebetta"]}',
                      style: TextStyle(
                        color: Colors.cyan,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'DM Academy',
                      ),
                    ),
                    Text(
                      'ลักษณะ: ${bettaList[index]["style"]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'DM Academy',
                      ),
                    ),
                    Text(
                      'จุดสังเกตุ: ${bettaList[index]["atten"]}',
                      style: TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: 'DM Academy',
                      ),
                    ),
                  ],
                ),
              );
            })
      )
    );
}




