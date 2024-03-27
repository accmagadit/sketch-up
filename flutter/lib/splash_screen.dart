import 'package:flutter/material.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(children: [
              Positioned.fill(
                  child: Image.asset(
                'assets/images/background.png',
                repeat: ImageRepeat.repeat,
              )),
              Center(
                child: Text(
                  "Sketch\nUp!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "game", fontSize: constraints.maxWidth / 6),
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 15,
                top: constraints.maxHeight / 1.5,
                child: Image.asset(
                  'assets/images/lamp.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 15,
                top: constraints.maxHeight / 9,
                child: Image.asset(
                  'assets/images/bohlam.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 3,
                top: constraints.maxHeight / 1.3,
                child: Image.asset(
                  'assets/images/books.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 1.6,
                top: constraints.maxHeight / 3.5,
                child: Image.asset(
                  'assets/images/chat.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 1.9,
                top: constraints.maxHeight / 20,
                child: Image.asset(
                  'assets/images/glass.png',
                  scale: 3,
                ),
              ),
              Positioned(
                top: constraints.maxHeight / 3,
                child: Image.asset(
                  'assets/images/love.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 3,
                top: constraints.maxHeight / 4,
                child: Image.asset(
                  'assets/images/pen.png',
                  scale: 3,
                ),
              ),
              Positioned(
                left: constraints.maxWidth / 1.6,
                top: constraints.maxHeight / 1.6,
                child: Image.asset(
                  'assets/images/wifi.png',
                  scale: 3,
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
