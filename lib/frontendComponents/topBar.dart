import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final Color barColor;
  final Color shadowColor;
  final String item1Label;
  final Color item1Color;
  final String item1Image;
  final String item2Label;
  final Color item2Color;
  final String item2Image;
  final String item3Label;
  final Color item3Color;
  final String item3Image;

  const TopBar({
    Key? key,
    required this.barColor,
    required this.shadowColor,
    required this.item1Label,
    required this.item1Color,
    required this.item1Image,
    required this.item2Label,
    required this.item2Color,
    required this.item2Image,
    required this.item3Label,
    required this.item3Color,
    required this.item3Image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: barColor,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Image.asset(
                  item1Image,
                  fit: BoxFit.contain,
                  height: 30.0,
                ),
                const SizedBox(width: 5),
                Text(
                  item1Label,
                  style: TextStyle(
                    color: item1Color,
                    fontSize: 16,
                    fontFamily: 'Pines',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        item2Label,
                        style: TextStyle(
                          color: item2Color,
                          fontSize: 16,
                          fontFamily: 'Pines',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        item2Image,
                        fit: BoxFit.contain,
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Text(
                        item3Label,
                        style: TextStyle(
                          color: item3Color,
                          fontSize: 16,
                          fontFamily: 'Pines',
                        ),
                      ),
                      const SizedBox(width: 5),
                      Image.asset(
                        item3Image,
                        fit: BoxFit.contain,
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
