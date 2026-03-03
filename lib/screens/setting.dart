import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../frontendComponents/goBackButton.dart';
import '../frontendComponents/primaryButtonMain.dart';
import 'profile.dart';
import 'aboutUs.dart';
import 'community.dart';

class Setting extends StatelessWidget {
  final User user;

  const Setting({super.key, required this.user});

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
                    'Settings',
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
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.person,
                          size: 30,
                          color: Color.fromRGBO(91, 91, 91, 1),
                        ),
                        title: const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(user: user),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.info,
                          size: 30,
                          color: Color.fromRGBO(91, 91, 91, 1),
                        ),
                        title: const Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutUs(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.group,
                          size: 30,
                          color: Color.fromRGBO(91, 91, 91, 1),
                        ),
                        title: const Text(
                          'Community',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: 'Aristotellica',
                            fontWeight: FontWeight.w100,
                            color: Color.fromRGBO(91, 91, 91, 1),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Community(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 200),
                      Align(
                        alignment: Alignment.center,
                        child: PrimaryButtonMain(
                          label: 'Sign Out',
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        ),
                      ),
                    ],
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
