import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:async';
import 'dart:io';

class FaceDetectorPage extends StatefulWidget {
  @override
  _FaceDetectorPageState createState() => _FaceDetectorPageState();
}

class _FaceDetectorPageState extends State<FaceDetectorPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image;
  var imageFile;
  final picker = ImagePicker();

  List<Rect> rect = new List<Rect>();
  bool isFaceDetected = false;

  final Widget takeImage = SvgPicture.asset(
      'assets/image.svg',
      semanticsLabel: 'Acme Logo'
  );

  Widget photoButton() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
      width: MediaQuery.of(context).size.width,
      height: 46.0,
      child: GestureDetector(
        onTap: (){
          selectImage(_scaffoldKey.currentContext);
        },
        child: Container(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt, color: Colors.white,),
                  Container(width: 6,),
                  Text(
                    'Analizar Foto',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18.0,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(12.0))
            )
        ),
      ),
    );
  }

  void selectImage(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
              color: Colors.white,
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new Center(
                      child: ListTile(
                          leading: new Icon(Icons.camera_alt),
                          title: new Text('Tomar Foto'),
                          onTap: () {
                            Navigator.pop(context);
                            fromCamera();
                          }),
                    ),
                    new Center(
                      child: ListTile(
                          leading: new Icon(Icons.photo),
                          title: new Text('Seleccionar Imagen'),
                          onTap: () {
                            Navigator.pop(context);
                            fromGallery();
                          }),
                    ),
                  ],
                ),
              )
          );
        }
    );
  }

  void fromCamera() async{
    print('Camara');
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    imageFile = await image.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);
    setState(() {
      imageFile = imageFile;
      _image = image;
    });
    _initializeVision();
  }

  void fromGallery() async{
    print('Galeria');
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    imageFile = await image.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);
    setState(() {
      imageFile = imageFile;
      _image = image;
    });
    _initializeVision();
  }

  void _initializeVision() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(_image);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await faceDetector.processImage(visionImage);
    if (rect.length > 0) {
      rect = new List<Rect>();
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);

      final double rotY =
          face.headEulerAngleY;
      final double rotZ =
          face.headEulerAngleZ;
    }

    setState(() {
      isFaceDetected = true;
    });
  }


  Widget bodyWidget(){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 10),
            width: 300,
            height: 400,
            child: _image == null? takeImage:
            isFaceDetected?
                   Center(
                    child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: FittedBox(
                      child: SizedBox(
                        width: imageFile.width.toDouble(),
                        height: imageFile.height.toDouble(),
                        child: CustomPaint(
                          painter:
                          FacePainter(rect: rect, imageFile: imageFile),
                          ),
                        ),
                      ),
                    ),
                  )
                :Container(),
          ),
          photoButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Face Detector'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: bodyWidget()
        )
    );
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({@required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.amber
          ..strokeWidth = 8.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
