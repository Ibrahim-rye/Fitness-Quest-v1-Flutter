import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/auth/accountCheck.dart';
import 'components/auth/loginScreen.dart';

class InitRoute extends StatelessWidget {
  const InitRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
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
          } else {
            final User? user = snapshot.data;
            if (user == null) {
              return const LoginScreen();
            } else {
              return FutureBuilder<bool?>(
                future: checkUserExists(user.uid),
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
                  } else {
                    return HomeOrAccount(user: user);
                  }
                },
              );
            }
          }
        },
      ),
    );
  }

  Future<bool?> checkUserExists(String userId) async {
    try {
      final bool exists = await userExists(userId);
      return exists;
    } catch (error) {
      print('Error checking user existence: $error');
      return false;
    }
  }
}
