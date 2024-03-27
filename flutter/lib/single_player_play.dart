import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:math';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DrawingApp(),
  ));
}

class DrawingApp extends StatefulWidget {
  const DrawingApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  int time = 30;
  double similarity = 0.0;
  late Timer _timer;
  List<String> classesModel = [
    'ambulans',
    'apel',
    'burung',
    'jam alarm',
    'kapal',
    'landasar',
    'lengan',
    'peri',
    'pesawat',
    'semut'
  ];
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  String level = '';

  @override
  void initState() {
    super.initState();
    setLevel();
    countingTimer();
    randomLevel();
    predictionEverySecond();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void countingTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > 0) {
        setState(() {
          time--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void cleanCanvas() {
    signatureGlobalKey.currentState!.clear();
  }

  void setLevel() {
    setState(() {
      level = classesModel[randomLevel()];
    });
  }

  int randomLevel() {
    Random index = Random();
    int randomIndex = index.nextInt(10);
    return randomIndex;
  }

  Future<Uint8List> signatureToPngImage(
      GlobalKey<SfSignaturePadState> signatureKey) async {
    ui.Image image = await signatureKey.currentState!.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    img.Image? imgData = img.decodeImage(pngBytes);
    Uint8List finalPngBytes = img.encodePng(imgData!);

    return finalPngBytes;
  }

  Future<Uint8List> preprocessImage() async {
    if (signatureGlobalKey.currentState != null) {
      Uint8List signaturePngBytes =
          await signatureToPngImage(signatureGlobalKey);
      img.Image? imgData = img.decodeImage(signaturePngBytes);
      img.Image resizedImg = img.copyResize(imgData!, width: 28, height: 28);
      img.Image grayscaleImg = img.grayscale(resizedImg);
      Uint8List finalPngBytes = img.encodePng(grayscaleImg);

      return finalPngBytes;
    } else {
      throw Exception("SignaturePad currentState is null");
    }
  }

  Future<List> prediction(Uint8List image) async {
    final interpreter =
        await tfl.Interpreter.fromAsset('assets/model/model.tflite');

    Float32List input = Float32List(28 * 28 * 1);
    for (int i = 0; i < image.length; i++) {
      input[i] = image[i] / 255.0;
    }

    var output = List.filled(1 * 10, 0).reshape([1, 10]);

    interpreter.run(input.buffer.asUint8List(), output);

    return output;
  }

  void predictionEverySecond() {
    int time = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time > 0) {
        _performPredictionAndUpdateSimilarity();
        time--;
      } else {
        _timer.cancel();
        print("Waktu habis");
      }
    });
  }

  void _performPredictionAndUpdateSimilarity() async {
    Uint8List processedImage;
    try {
      processedImage = await preprocessImage();
      List resultPrediction = await prediction(processedImage);

      int index =
          classesModel.indexOf(level); // Mendapatkan indeks kelas terpilih.

      setState(() {
        similarity = resultPrediction[0]
            [index]; // Update similarity berdasarkan indeks kelas terpilih.
      });

      print(resultPrediction[0][index]);
      print(level);
      print(index);
      print(resultPrediction);
    } catch (e) {
      print("Error during prediction: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Center(child: Text('')),
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background.png',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: constraints.maxHeight / 15),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Text(
                            '$time',
                            style: TextStyle(
                              fontFamily: 'number',
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        level,
                        style: TextStyle(fontFamily: 'game', fontSize: 80),
                      ),
                      Container(
                        height: constraints.maxWidth / 1.2,
                        width: constraints.maxWidth / 1.2,
                        decoration: BoxDecoration(border: Border.all()),
                        child: SfSignaturePad(
                          key: signatureGlobalKey,
                          minimumStrokeWidth: 3,
                          maximumStrokeWidth: 3,
                          strokeColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        (similarity * 100).toStringAsFixed(2) + '%',
                        style: TextStyle(
                          fontFamily: 'number',
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 25),
                      InkWell(
                        onTap: () {
                          cleanCanvas();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
