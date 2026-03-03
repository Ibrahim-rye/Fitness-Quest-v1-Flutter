import 'package:flutter/material.dart';
import '../frontendComponents/communityBanner.dart';
import '../frontendComponents/goBackButton.dart';

class Community extends StatelessWidget {
  const Community({super.key});

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
                    'Community',
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
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(26.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Join Our Community',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Our community is a space where you can connect with other fitness enthusiasts, share your journey, and find motivation. Join us today and be part of a supportive and encouraging environment.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Community Guidelines',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Be respectful: Treat others with kindness and respect.\n'
                          '• Stay positive: Share positive and motivating content.\n'
                          '• No spam: Avoid posting irrelevant or promotional content.\n'
                          '• Be supportive: Encourage others on their fitness journeys.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        SizedBox(height: 40),
                        CommunityBanner(
                          text1: 'Coming Soon',
                          imageUrl: 'assets/images/Fitniwelcome.png',
                          bannerColor: Color.fromARGB(255, 255, 239, 160),
                          shadowColor: Color.fromARGB(255, 255, 131, 96),
                        ),
                        SizedBox(height: 20),
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
