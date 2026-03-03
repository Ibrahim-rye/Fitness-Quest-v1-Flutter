import 'package:flutter/material.dart';

class HomeLog2 extends StatelessWidget {
  final String text;

  const HomeLog2({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 26, right: 10),
        height: 40.0,
        width: 170.0,
        child: Stack(
          children: [
            Container(
              height: 130.0,
              width: 170.0,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 131, 96),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 131, 96),
                    spreadRadius: 1.5,
                    blurRadius: 0,
                    offset: Offset(0, -2),
                  ),
                  BoxShadow(
                    color: Color.fromARGB(255, 255, 131, 96),
                    spreadRadius: 1.5,
                    blurRadius: 0,
                    offset: Offset(0, 15),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 35.0,
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Aristotellica',
                  fontWeight: FontWeight.w700,
                  color: Color.fromRGBO(255, 255, 255, 1),
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
