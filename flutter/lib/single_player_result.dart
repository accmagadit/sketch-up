import 'package:flutter/material.dart';
import 'package:sketch_up/buttonWidget.dart';

void main(List<String> args) {
  runApp(SinglePlayerResult());
}

class SinglePlayerResult extends StatefulWidget {
  const SinglePlayerResult({super.key});

  @override
  State<SinglePlayerResult> createState() => _SinglePlayerResultState();
}

class _SinglePlayerResultState extends State<SinglePlayerResult> {
  List<String> resultStar = [];
  double result = 20.98;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                SizedBox(height: constraints.maxHeight/10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ButtonResult(text: 'Gambar', status: true),
                    ButtonResult(text: 'Foto', status: false),
                  ],
                ),
                SizedBox(height: constraints.maxHeight/40,),
                Container(
                  width: constraints.maxWidth / 1.4,
                  height: 300,
                  color: Colors.black54,
                ),
                SizedBox(height: constraints.maxHeight/40,),
                Text(
                  '$result%',
                  style: TextStyle(fontFamily: 'number'),
                ),
                SizedBox(height: constraints.maxHeight/30,),
                Row(
                  children: [],
                ),
                Text(
                  'Kamu sudah hebat\nTingkatkan ya!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'game', fontSize: 30),
                ),
                SizedBox(height: constraints.maxHeight/15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.home_outlined),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 60,
                        height: 60,
                        child: Icon(Icons.autorenew),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            shape: BoxShape.circle,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
