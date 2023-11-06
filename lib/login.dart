import 'package:betta_detection/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bglogin.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/loginbetta-removebg-preview.png', width: 450, height: 450),
              SizedBox(height: 20),
              Text(
                'ยินดีต้อนรับ',
                style: TextStyle(fontSize: 28,color: Colors.white, fontWeight: FontWeight.bold ,fontFamily: 'DM Academy'),
              ),
              SizedBox(height: 10),
              Text(
                'แอปพลิเคชั่น ช่วยจำแนกสายพันธุ์ปลากัดไทย',
                style: TextStyle(fontSize: 20,color: Colors.white ,fontFamily: 'DM Academy'),
              ),
              SizedBox(height: 10),
              Text(
                'An application that helps classify Thai fighting fish species.',
                style: TextStyle(fontSize: 15,color: Colors.white ,fontWeight: FontWeight.bold ,fontFamily: 'DM Academy'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // TODO: เพิ่มโค้ดสำหรับการเข้าสู่ระบบ
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Betta Detection App")),);
                },
                child: Text('เริ่มต้นใช้งาน',style: TextStyle(fontSize: 18 ,fontFamily: 'DM Academy' ,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
