import 'package:flutter/material.dart';

class StatBoxMain extends StatelessWidget {
  final String title;
  final List<Map<String, String>> stats;

  const StatBoxMain({
    Key? key,
    required this.title,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(255, 239, 160, 1),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(255, 131, 96, 1),
            offset: Offset(0, 5),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 45.0,
                fontFamily: 'Aristotellica',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 131, 96, 1),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: 2.4,
            color: const Color.fromRGBO(248, 153, 80, 1),
            margin: const EdgeInsets.only(bottom: 8.0),
          ),
          Column(
            children: stats.map((stat) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    stat['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontFamily: 'Pines',
                      color: Color.fromRGBO(68, 74, 79, 1),
                    ),
                  ),
                  Text(
                    stat['value'] ?? '',
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontFamily: 'Pines',
                      color: Color.fromRGBO(68, 74, 79, 1),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
