import 'package:flutter/material.dart';

class CustomBanner2 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color bannerColor;
  final Color shadowColor;
  final Color textColor;
  final double bannerHeight;
  final double imageHeight;

  const CustomBanner2({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.textColor,
    required this.bannerColor,
    required this.shadowColor,
    required this.bannerHeight,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: bannerHeight,
      decoration: BoxDecoration(
        color: bannerColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 1.5,
            blurRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 8.0, 0.0, 8.0),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 40.0,
                        fontFamily: 'Aristotellica',
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 8.0,
                    top: 8.0,
                    bottom: 8.0,
                    left: 8.0,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.contain,
                      height: imageHeight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
