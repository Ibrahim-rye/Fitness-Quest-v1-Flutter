import 'package:flutter/material.dart';

class DietLog extends StatelessWidget {
  final String text1;
  final String text2;
  final Color bannerColor;
  final Color shadowColor;
  final Widget child;

  const DietLog({
    Key? key,
    required this.text1,
    required this.text2,
    required this.bannerColor,
    required this.shadowColor,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 26, right: 10),
        height: 130.0,
        width: 170.0,
        child: Stack(
          children: [
            Container(
              height: 130.0,
              width: 170.0,
              decoration: BoxDecoration(
                color: bannerColor,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1.5,
                    blurRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1.5,
                    blurRadius: 0,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Row(
                  children: [
                    Text(
                      text1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontFamily: 'Pines',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 131, 96),
                        height: 1.0,
                      ),
                    ),
                    Text(
                      text2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28.0,
                        fontFamily: 'Pines',
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(73, 73, 73, 1),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
