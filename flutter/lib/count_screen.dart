import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sketch_up/splash_screen.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    home: CountScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class CountScreen extends StatefulWidget {
  const CountScreen({Key? key}) : super(key: key);

  @override
  State<CountScreen> createState() => _CountScreenState();
}

class _CountScreenState extends State<CountScreen> {
  var counting = ['Tiga', 'Dua', 'Satu', 'Up!'];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (currentIndex < counting.length - 1) {
        setState(() {
          currentIndex++;
        });
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat widget di dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              repeat: ImageRepeat.repeat,
            ),
          ),
          Center(
            child: Text(
              counting[currentIndex],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "game",
                fontSize: MediaQuery.of(context).size.width / 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
