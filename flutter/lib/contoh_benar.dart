import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DrawingApp(),
  ));
}

class DrawingApp extends StatefulWidget {
  DrawingApp({Key? key}) : super(key: key);

  @override
  _DrawingAppState createState() => _DrawingAppState();
}

class _DrawingAppState extends State<DrawingApp> {
  int time = 30;
  String object = "bear";
  double similarity = 0.0;
  late Timer _timer;
  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    countingTimer();
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

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  Future<Uint8List> preprocessImage() async {
    // Lakukan hal yang serupa dengan memuat dan memproses gambar
    // Ganti 'path_to_your_image.png' dengan path gambar yang sesuai
    ByteData imageData = await rootBundle.load('assets/images/lamp.png');
    Uint8List pngBytes = imageData.buffer.asUint8List();

    img.Image? imgData = img.decodeImage(pngBytes);
    img.Image resizedImg = img.copyResize(imgData!, width: 28, height: 28);
    img.Image grayscaleImg = img.grayscale(resizedImg);
    Uint8List finalPngBytes = img.encodePng(grayscaleImg);

    return finalPngBytes;
  }

void prediction(Uint8List image) async {
  final interpreter = await tfl.Interpreter.fromAsset('assets/model/model.tflite');

  // Ubah Uint8List ke Float32List dengan dimensi yang sesuai
  Float32List input = Float32List(28 * 28 * 1); // Sesuaikan dengan ukuran input yang diharapkan
  for (int i = 0; i < image.length; i++) {
    input[i] = image[i] / 255.0; // Normalisasi nilai piksel jika diperlukan
  }

  var output = List.filled(1 * 10, 0).reshape([1, 10]);

  interpreter.run(input.buffer.asUint8List(), output); // Jalankan model dengan input yang sudah diubah

  print(output);
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
                        object,
                        style: TextStyle(fontFamily: 'game', fontSize: 80),
                      ),
                      Container(
                        height: constraints.maxHeight / 2,
                        width: constraints.maxWidth / 1.4,
                        child: SfSignaturePad(
                          key: signatureGlobalKey,
                          minimumStrokeWidth: 3,
                          maximumStrokeWidth: 3,
                          strokeColor: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text(
                        '$similarity%',
                        style: TextStyle(
                          fontFamily: 'number',
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight / 25),
                      InkWell(
                        onTap: () async {
                          Uint8List processedImage =
                              await preprocessImage(); // Memuat dan memproses gambar
                          prediction(
                              processedImage); // Melakukan prediksi dengan gambar yang telah diproses
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(Icons.save),
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
