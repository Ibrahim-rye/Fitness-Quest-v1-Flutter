import 'package:flutter/material.dart';

class CustomBanner2 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final Color bannerColor;
  final Color strokeColor;
  final Color textColor;

  const CustomBanner2({
    Key? key,
    required this.text,
    required this.imageUrl,
    required this.textColor,
    required this.bannerColor,
    required this.strokeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.0,
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(
          top: BorderSide(color: strokeColor, width: 2.0),
          bottom: BorderSide(color: strokeColor, width: 2.0),
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(32.0, 8.0, 0.0, 8.0),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 50.0,
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
                child: Image.asset(
                  imageUrl,
                  height: 800.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
