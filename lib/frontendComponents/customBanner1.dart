import 'package:flutter/material.dart';

class CustomBanner extends StatelessWidget {
  final String text1;
  final String text2;
  final String imageUrl;
  final Color bannerColor;
  final Color shadowColor;

  const CustomBanner({
    Key? key,
    required this.text1,
    required this.text2,
    required this.imageUrl,
    required this.bannerColor,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      height: 150.0,
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
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0.0, 8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text1,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Aristotellica',
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(73, 73, 73, 1),
                        height: 1.0,
                      ),
                    ),
                    Text(
                      text2,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Aristotellica',
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 255, 131, 96),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.contain,
                  height: 130.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
