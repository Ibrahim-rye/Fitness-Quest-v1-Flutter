import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/services/firestore.dart';
import '../../frontendComponents/primaryButtonMain.dart';
import '../../frontendComponents/customBanner2.dart';
import '../../frontendComponents/goBackButton.dart';

class EditProfile extends StatefulWidget {
  final User user;
  final String? currentName;
  final String? currentNick;
  final String? currentAge;

  const EditProfile({
    Key? key,
    required this.user,
    this.currentName,
    this.currentNick,
    this.currentAge,
  }) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String nick;
  late String age;
  String? ageError;

  @override
  void initState() {
    super.initState();
    name = widget.currentName ?? '';
    nick = widget.currentNick ?? '';
    age = widget.currentAge ?? '';
  }

  Future<void> updateUserProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (int.tryParse(age) == null) {
        setState(() {
          ageError = 'Please enter a valid integer value for age';
        });
        return;
      } else {
        setState(() {
          ageError = null;
        });
      }

      try {
        FirestoreService firestoreService = FirestoreService();
        await firestoreService.updateUser(
          widget.user.uid,
          name: name,
          nick: nick,
          age: age,
        );
        Navigator.pop(context);
      } catch (error) {
        print('Error updating user profile: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60.0),
              const CustomBanner2(
                text: 'Edit Profile',
                imageUrl: 'assets/images/fitniregister.png',
                textColor: Colors.white,
                bannerColor: Color.fromARGB(255, 255, 131, 96),
                shadowColor: Color.fromARGB(255, 201, 87, 54),
                bannerHeight: 130,
                imageHeight: 150,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 10.0),
                          const Text(
                            'Name',
                            style: TextStyle(
                              fontFamily: 'Aristotellica',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 131, 96),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            initialValue: name,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'Pines'),
                            onSaved: (value) => name = value!,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a name' : null,
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Nickname',
                            style: TextStyle(
                              fontFamily: 'Aristotellica',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 131, 96),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            initialValue: nick,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'Pines'),
                            onSaved: (value) => nick = value!,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a nickname'
                                : null,
                          ),
                          const SizedBox(height: 10.0),
                          const Text(
                            'Age',
                            style: TextStyle(
                              fontFamily: 'Aristotellica',
                              fontSize: 22.0,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 255, 131, 96),
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          TextFormField(
                            initialValue: age,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2.0,
                                ),
                              ),
                            ),
                            style: const TextStyle(fontFamily: 'Pines'),
                            onSaved: (value) => age = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an age';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid integer value for age';
                              }
                              return null;
                            },
                          ),
                          if (ageError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                ageError!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: PrimaryButtonMain(
                  label: 'Save Changes',
                  onPressed: updateUserProfile,
                ),
              ),
              const SizedBox(height: 20),
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
