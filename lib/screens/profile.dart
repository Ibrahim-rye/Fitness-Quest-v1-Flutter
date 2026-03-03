import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/screens/editProfile.dart';
import '../components/avatar/avatarIndex.dart';
import '../../frontendComponents/statBox.dart';
import '../../frontendComponents/statBoxMain.dart';
import '../../frontendComponents/topSection.dart';
import '../../frontendComponents/primaryButton.dart';
import '../screens/Goals.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({super.key, required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? nick;
  int? age;
  String? gender;
  bool isLoading = true;
  int? level;
  int? fitniScore;
  String? rank;
  int? height;
  int? weight;
  int? caloriesBurned;
  int? daysTracked;
  int? streak;
  int? workoutsCompleted;
  int? bossesDefeated;

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
    setState(() {
      isLoading = true;
    });
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        Map<String, dynamic>? userData =
            userSnapshot.docs.first.data() as Map<String, dynamic>?;

        if (userData != null) {
          setState(() {
            age = userData['age'] != null
                ? int.tryParse(userData['age'].toString())
                : null;
            gender = userData['gender'] ?? 'Unknown';
            name = userData['name'] ?? 'Unknown';
            nick = userData['nick'] ?? 'Unknown';
            height = userData['height'] != null
                ? int.tryParse(userData['height'].toString())
                : null;
            weight = userData['weight'] != null
                ? int.tryParse(userData['weight'].toString())
                : null;
          });
        }
      }

      QuerySnapshot questSnapshot = await firestore
          .collection('fitniQuest')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (questSnapshot.docs.isNotEmpty) {
        Map<String, dynamic>? questData =
            questSnapshot.docs.first.data() as Map<String, dynamic>?;
        print(questData);
        if (questData != null) {
          setState(() {
            level = questData['level'];
            fitniScore = questData['questScore'];
            rank = questData['rank'];
            daysTracked = questData['daysTracked'];
            streak = questData['streak'];
            workoutsCompleted = questData['workoutsCompleted'];
            bossesDefeated = questData['bossesDefeated'];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching user data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? Center(
                child: Image.asset(
                  "assets/images/loadingicon.gif",
                  width: 200,
                  height: 200,
                  gaplessPlayback: true,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20.0),
                    TopSection(
                      onEditPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(
                              user: widget.user,
                              currentName: name,
                              currentNick: nick,
                              currentAge: age?.toString(),
                              // currentGender: gender,
                            ),
                          ),
                        );
                        fetchUserPreferences();
                      },
                      onAvatarPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarCustomizerPage(),
                          ),
                        );
                        fetchUserPreferences();
                      },
                    ),
                    // AvatarView(),
                    const SizedBox(height: 20.0),
                    StatBoxMain(
                      title: nick ?? 'Unknown',
                      stats: [
                        {'name': 'Nickname', 'value': nick ?? 'Unknown'},
                        {
                          'name': 'Level',
                          'value': level?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Fitni Score',
                          'value': fitniScore?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Rank',
                          'value': rank?.toString() ?? 'Unknown'
                        },
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    StatBox(
                      title: 'Profile',
                      stats: [
                        {'name': 'Name', 'value': name ?? 'Unknown'},
                        {
                          'name': 'Weight',
                          'value': weight?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Height',
                          'value': height?.toString() ?? 'Unknown'
                        },
                        {'name': 'Age', 'value': age?.toString() ?? 'Unknown'},
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    StatBox(
                      title: 'Progression',
                      stats: [
                        {
                          'name': 'Days Tracked',
                          'value': daysTracked?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Streak',
                          'value': streak?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Workouts Completed',
                          'value': workoutsCompleted?.toString() ?? 'Unknown'
                        },
                        {
                          'name': 'Bosses Defeated',
                          'value': bossesDefeated?.toString() ?? 'Unknown'
                        },
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Goals(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      label: 'Edit Goals',
                    ),
                    const SizedBox(height: 20.0)
                  ],
                ),
              ),
      ),
    );
  }
}
