import 'package:flutter/material.dart';

class CommunityBanner extends StatelessWidget {
  final String text1;
  final Color bannerColor;
  final Color shadowColor;
  final String imageUrl;

  const CommunityBanner({
    Key? key,
    required this.text1,
    required this.bannerColor,
    required this.shadowColor,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45.0),
      height: 250.0,
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
      child: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            flex: 1,
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
                    color: Color.fromARGB(255, 255, 131, 96),
                    height: 0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Image.asset(
                imageUrl,
                height: 240.0,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
