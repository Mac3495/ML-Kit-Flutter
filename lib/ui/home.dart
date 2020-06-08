import 'package:flutter/material.dart';
import 'package:mlkitapp/ui/text_recognition.dart';
import 'package:mlkitapp/ui/barcode_page.dart';
import 'package:mlkitapp/ui/face_detector_page.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  Widget cardOption(String option, int optionTap){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 20, left: 50, right: 50),
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
            border: new Border.all(
                color: Colors.black26,
                width: 5.0,
                style: BorderStyle.solid
            ),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: Colors.white
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
                color: Colors.black45,
                fontSize: 24.0,
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
      onTap: (){
        if(optionTap == 0){
          Navigator.push(context, MaterialPageRoute(builder: (context) => BarcodePage()),);
        } else if(optionTap == 1){
          Navigator.push(context, MaterialPageRoute(builder: (context) => TextRecognition()),);
        } else if(optionTap == 2){
          Navigator.push(context, MaterialPageRoute(builder: (context) => FaceDetectorPage()),);
        }
      },
    );
  }



  Widget homeWidget(){
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            cardOption('Barcode Detector', 0),
            cardOption('Text Recognition', 1),
            cardOption('Face Detector', 2),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MLKit Demos'),
        centerTitle: true,
      ),
      body: homeWidget(),
    );
  }
}
