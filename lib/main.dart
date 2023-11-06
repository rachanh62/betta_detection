import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:betta_detection/splash_screen.dart';
import 'package:betta_detection/inform_betta.dart';
import 'package:betta_detection/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Betta Detection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? selectedImage;
  var message = "", texts = "";
  String conf = "";
  var enbetta = ["Butterfly-betta","Chinese-betta","Cronwtail-betta","DoubleTail-betta","Dumbo-betta","Halfmoon-betta","Marble-betta","Pot-betta","Siamese-betta","Tancho-betta"];
  var thbetta = ["ปลากัดลายผีเสื้อ","ปลากัดจีน","ปลากัดหางมงกุฎ","ปลากัดสองหาง","ปลากัดหูช้าง","ปลากัดฮาล์ฟมูน","ปลากัดลายหินอ่อน","ปลากัดลูกหม้อ","ปลากัดป่า","ปลากัดทันโจ"];
  var dis = ["อัพโหลด","อัพโหลดอีกครั้ง","ถ่ายรูป","ถ่ายรูปอีกครั้ง"];
  var indextake = 2,indexget = 0;
  var datares;

  void uploadImage() async {
    final request = http.MultipartRequest("POST", Uri.parse("https://vision.eng.nu.ac.th/bettafishdetect/uploaded"));

    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile('image_file',
        selectedImage!.readAsBytes().asStream(), selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    datares = resJson;
    log('data: $resJson');
    print(resJson);
    //print(datares);
    if (resJson.toString() == "[]"){
      print('is empty');
    }else {
      for (var i = 0; i < 10; i++) {
        if (resJson[0][4] == enbetta[i]) {
          message = thbetta[i];
        }
      }
    }
    setState(() {
      if (resJson.toString() == "[]"){
        message = "ไม่สามารถระบุได้";
        conf = "กรุณาลองใหม่อีกครั้ง";
      }else {
        conf = "ค่าความมั่นใจ " + resJson[0][5].toStringAsFixed(2) + "%";
      }
    });

  }

  @override
  void initState() {
    super.initState();
    uploadImage();
  }

  Future getImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    selectedImage = File(pickImage!.path);
    setState(() {
      if (selectedImage != null) {
        message = "กำลังประมวลผล"; conf = "โปรดรอสักครู่";
        indexget = 1; texts = "ปลากัดสายพันธุ์";
        uploadImage();
      }
    });
  }

  Future takeImage() async {
    final pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
    selectedImage = File(pickImage!.path);
    setState(() {
      if (selectedImage != null) {
        message = "กำลังประมวลผล"; conf = "โปรดรอสักครู่";
        indextake = 3; texts = "ปลากัดสายพันธุ์";
        uploadImage();
      }
    });
  }

  bool _isShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.title,style: TextStyle(fontSize: 24 ,fontFamily: 'DM Academy',color: Colors.white),),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              selectedImage == null
                  ? const Text("อัปโหลดภาพหรือถ่ายภาพปลากัดเพื่อทำการประมวล"
                  ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal ,fontFamily: 'DM Academy',color: Colors.white))
                  : Image.file(selectedImage!,
                        height: 230.0,
                        width: 260.0,
              ),
              SizedBox(height: 10),
              Container(
                child: Text(
                  texts,
                  style: const TextStyle(fontSize: 20 ,fontFamily: 'DM Academy',color: Colors.white)
                ),
              ),
              Container(
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  margin: const EdgeInsets.all(10),
                  height: 95,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    message + "\n" + conf,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24 ,fontFamily: 'DM Academy',color: Colors.white70),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                                  takeImage();
                                  _isShow = true;
                                  },
                             );
                        },
                        icon: Icon(Icons.photo_camera, color: Colors.white),
                        label: Text(dis[indextake],
                            style: TextStyle(
                              color: Colors.white ,fontSize: 16 ,fontWeight: FontWeight.bold ,fontFamily: 'DM Academy'
                            ))),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blue),
                        ),
                        onPressed: () {
                          setState(() {
                            getImage();
                            _isShow = true;
                          },
                          );
                        },
                        icon: Icon(Icons.upload_file, color: Colors.white),
                        label: Text(dis[indexget],
                            style: TextStyle(
                              color: Colors.white ,fontSize: 18 ,fontWeight: FontWeight.bold ,fontFamily: 'DM Academy'
                            ))),
                  ),
                ],
              ),
              SizedBox(height: 6),
              Visibility(
                  visible: _isShow,
                  child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => informbetta(textbetta: message),),);
                      },
                      icon: Icon(Icons.add_chart, color: Colors.white),
                      label: Text("ดูข้อมูลเพิ่มเติม",
                          style: TextStyle(
                            color: Colors.white ,fontSize: 16 ,fontWeight: FontWeight.bold ,fontFamily: 'DM Academy'
                          ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


