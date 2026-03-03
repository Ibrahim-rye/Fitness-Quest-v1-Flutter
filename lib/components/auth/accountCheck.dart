import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../screens/home.dart';
import 'EmailVerificationScreen.dart';

class HomeOrAccount extends StatelessWidget {
  final User user;

  const HomeOrAccount({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userExists(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset(
              "assets/images/loadingicon.gif",
              width: 200,
              height: 200,
              gaplessPlayback: true,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data == true) {
          return HomePage(user: user);
        } else {
          return EmailVerificationScreen(user: user);
        }
      },
    );
  }
}

Future<bool> userExists(String userId) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('Checking user document for $userId');

    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('User document $userId found');
    } else {
      print('User document $userId not found');
    }
    return querySnapshot.docs.isNotEmpty;
  } catch (error) {
    print('Error checking user document: $error');
    return false;
  }
}
