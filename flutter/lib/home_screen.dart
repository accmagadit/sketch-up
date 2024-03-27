import 'package:flutter/material.dart';
import 'package:sketch_up/buttonWidget.dart';

void main(List<String> args) {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/singleplayer.png'),
                            fit: BoxFit.none,
                            scale: 0.9),
                      ),
                    ),
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/multiplayer.png'),
                            fit: BoxFit.none,
                            scale: 0.9),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonGame(text: 'Single Player'),
                      ButtonGame(text: 'Multi Player')
                    ],
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth / 1.6,
                  top: constraints.maxHeight / 20,
                  child: Image.asset(
                    'assets/images/glass.png',
                    scale: 3,
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth / 1.5,
                  top: constraints.maxHeight / 2.2,
                  child: Image.asset(
                    'assets/images/chat.png',
                    scale: 3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
