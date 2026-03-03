import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/screens/editGoals.dart';
import '../../frontendComponents/statBox.dart';
import '../frontendComponents/primaryButtonMain.dart';

class Goals extends StatefulWidget {
  final User user;

  const Goals({Key? key, required this.user}) : super(key: key);

  @override
  State<Goals> createState() => _GoalsState();
}

class _GoalsState extends State<Goals> {
  String? activityLevel;
  String? difficulty;
  String? goal;
  String? height;
  String? weight;
  bool? needsDumbell;

  @override
  void initState() {
    super.initState();
    fetchUserPreferences();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserPreferences();
  }

  Future<void> fetchUserPreferences() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching user preferences for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('User data found');
        Map<String, dynamic>? userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;
        print('User data: $userData');
        if (userData != null) {
          setState(() {
            activityLevel = userData['activityLevel'] ?? 'Unknown';
            difficulty = userData['difficulty'] ?? 'Unknown';
            goal = userData['goal'] ?? 'Unknown';
            height = userData['height'] ?? 'Unknown';
            weight = userData['weight'] ?? 'Unknown';
            needsDumbell = userData['needsDumbell'];
          });
        }
      } else {
        print('No user data found');
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40.0),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/goals.png',
                      height: 160.0,
                      width: 160.0,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16.0),
                      StatBox(
                        title: 'Personal Data',
                        stats: [
                          {'name': 'Height', 'value': height ?? 'Loading...'},
                          {'name': 'Weight', 'value': weight ?? 'Loading...'},
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      StatBox(
                        title: 'Preferences',
                        stats: [
                          {
                            'name': 'Activity Level',
                            'value': activityLevel ?? 'Loading...'
                          },
                          {
                            'name': 'Difficulty',
                            'value': difficulty ?? 'Loading...'
                          },
                          {'name': 'Goal', 'value': goal ?? 'Loading...'},
                          {
                            'name': 'Needs Dumbbell',
                            'value': needsDumbell != null
                                ? (needsDumbell! ? 'Yes' : 'No')
                                : 'Unknown',
                          },
                        ],
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButtonMain(
                    label: 'Edit Goals',
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditGoals(
                            user: widget.user,
                            currentActivity: activityLevel,
                            currentDifficulty: difficulty,
                            currentGoal: goal,
                            currentHeight: height,
                            currentWeight: weight,
                            currentNeedsDumbell: needsDumbell,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          activityLevel = result['activityLevel'];
                          difficulty = result['difficulty'];
                          goal = result['goal'];
                          height = result['height'];
                          weight = result['weight'];
                          needsDumbell = result['needsDumbell'];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
