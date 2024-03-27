import 'package:flutter/material.dart';

Widget ButtonGame({required String text}) {
  return Container(
    width: 200,
    height: 200,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/button.png'),
      ),
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'game',
          fontSize: 25, // Ubah ukuran teks sesuai kebutuhan
        ),
      ),
    ),
  );
}

Widget ButtonResult({required String text,required bool status}) {
  return Container(
    width: 100,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: status?Color(0xffD9D9D9) : Color(0xffF0F0F0)
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'number',
          fontSize: 15, // Ubah ukuran teks sesuai kebutuhan
        ),
      ),
    ),
  );
}
