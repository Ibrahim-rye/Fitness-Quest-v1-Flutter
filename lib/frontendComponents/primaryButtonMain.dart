import 'package:flutter/material.dart';

class PrimaryButtonMain extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const PrimaryButtonMain({
    Key? key,
    required this.onPressed,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 201, 87, 54),
            spreadRadius: 1.5,
            blurRadius: 0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 131, 96),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 25, bottom: 20),
          shadowColor: const Color.fromARGB(255, 255, 131, 96),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 26.0,
            fontFamily: 'Aristotellica',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
