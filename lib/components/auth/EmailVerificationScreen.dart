import 'package:fitness/components/auth/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../timer/beginningofTime.dart';
import '../../frontendComponents/goBackButton.dart';
import '../account_creation/account_creator_index.dart';

class EmailVerificationScreen extends StatefulWidget {
  final User user;

  const EmailVerificationScreen({Key? key, required this.user})
      : super(key: key);

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isVerified = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkEmailVerified();
  }

  void _checkEmailVerified() async {
    await widget.user.reload();

    if (widget.user.emailVerified) {
      setState(() {
        _isVerified = true;
      });
    } else {
      setState(() {
        _errorMessage = 'Please verify your email before proceeding.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/fitniregister.png',
                    height: 160.0,
                    width: 160.0,
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: _isVerified
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Your email has been verified.',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey,
                          fontFamily: 'Aristotellica',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
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
                          onPressed: () {
                            initializeAll();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    CreatorIndex(user: widget.user),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 131, 96),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                          ),
                          child: const Text(
                            'Proceed',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Aristotellica',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Waiting for email verification...',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.grey,
                          fontFamily: 'Aristotellica',
                        ),
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 10),
                          child: Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Color.fromARGB(255, 237, 139, 132),
                              fontFamily: 'Aristotellica',
                            ),
                          ),
                        ),
                      Container(
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
                          onPressed: () {
                            _checkEmailVerified();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 255, 131, 96),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                          ),
                          child: const Text(
                            'I have verified my email',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontFamily: 'Aristotellica',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 50, left: 40, right: 40),
                        child: Text(
                          'After verifying the email Please restart the application',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromARGB(255, 255, 131, 96),
                            fontFamily: 'Aristotellica',
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          Positioned(
            top: 10.0,
            left: 10.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoBackButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
