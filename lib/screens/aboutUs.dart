import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../frontendComponents/goBackButton.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50),
              Container(
                width: double.infinity,
                height: 100,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 131, 96),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 201, 87, 54),
                      spreadRadius: 1.5,
                      blurRadius: 0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: 'Aristotellica',
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Creators',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Umais Usmani and Muhammad Ibrahim, the passionate and dedicated creators of this fitness app. As graduate students from GC University, Pakistan, we've combined our love for programming, design, and fitness to bring you the ultimate tools and resources for achieving your health goals.",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Our Mission',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'At our fitness app, we are committed to helping you reach your health and fitness objectives. We offer personalized diet plans, comprehensive food logging, and a supportive community to keep you motivated every step of the way.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Contact Us',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Instagram: ',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Aristotellica',
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(91, 91, 91, 1),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Open Instagram profile link
                                launchUrlString(
                                    'https://www.instagram.com/maisketchar?igsh=MXhiZ3RjMWd2czAzYQ==');
                              },
                              child: const Text(
                                '@maishetchar',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Pines',
                                  fontWeight: FontWeight.w100,
                                  color: Color.fromARGB(255, 255, 131, 96),
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoBackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
