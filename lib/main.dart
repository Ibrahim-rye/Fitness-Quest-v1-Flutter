import 'package:fitness/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './initRouteHandler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './frontendComponents/SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // final timeHandler = TimeHandler(user);
    // timeHandler.start();
  } else {
    debugPrint('No user is currently signed in.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => SplashScreen(),
        '/init': (context) => const InitRoute(),
      },
      initialRoute: '/',
      builder: (context, child) {
        return SafeArea(
          child: child!,
        );
      },
    );
  }
}
