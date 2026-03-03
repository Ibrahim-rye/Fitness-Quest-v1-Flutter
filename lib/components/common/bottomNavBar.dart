import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness/frontendComponents/topSectionHome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../components/dietlogger/foodLog.dart';
import 'package:fitness/components/IbrahimsStuff/lib/exercise.dart';
import '../timer/timeHandler.dart';
import '../timer/resetDietandWorkouts.dart';

import '../../screens/profile.dart';
import '../../screens/goals.dart';
import '../../screens/setting.dart';
import '../../screens/shop.dart';
import '../../screens/story.dart';

import '../../frontendComponents/customBanner1.dart';
import '../../frontendComponents/workoutLog.dart';
import '../../frontendComponents/dietLog.dart';
import '../../frontendComponents/homeLog2.dart';

class BottomNavBar extends StatefulWidget {
  final User user;

  const BottomNavBar({super.key, required this.user});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(user: widget.user),
      Story(user: widget.user),
      Profile(user: widget.user),
      Goals(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 255, 131, 96),
        unselectedItemColor: const Color.fromARGB(255, 255, 179, 121),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/home.png'), size: 40.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/story-book.png'),
                size: 40.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/user.png'), size: 40.0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/icons/flag.png'), size: 40.0),
            label: '',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? displayName;
  int totalCalories = 0;
  int totalExercises = 0;
  int tickExercises = 0;
  late StreamSubscription<DocumentSnapshot> _tickExercisesSubscription;
  late StreamSubscription<QuerySnapshot> _caloriesSubscription;
  late TimeHandler _timeHandler;

  @override
  void initState() {
    super.initState();
    _timeHandler = TimeHandler();
    fetchDisplayName();
    subscribeToCalories();
    subscribeToTickExercises();
    fetchCurrentDayIndex();
  }

  @override
  void dispose() {
    _tickExercisesSubscription.cancel();
    _caloriesSubscription.cancel();
    super.dispose();
  }

  Future<void> fetchDisplayName() async {
    User? updatedUser = FirebaseAuth.instance.currentUser;
    String? name = updatedUser?.displayName;

    setState(() {
      displayName = name;
    });
  }

  void subscribeToCalories() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    String userId = currentUser.uid;

    _caloriesSubscription = FirebaseFirestore.instance
        .collection('foodLogs')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((QuerySnapshot querySnapshot) async {
      int consumedCalories = 0;

      for (var doc in querySnapshot.docs) {
        consumedCalories += (doc['consumedCalories'] as int? ?? 0);
      }

      QuerySnapshot userQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: userId)
          .get();

      DocumentSnapshot userSnapshot = userQuerySnapshot.docs.first;
      int caloricNeed = userSnapshot['caloricNeed']?.toInt() ?? 0;

      int remainingCalories = caloricNeed - consumedCalories;

      setState(() {
        totalCalories = remainingCalories;
      });

      print("Caloric Need: $caloricNeed");
      print("Consumed Calories: $consumedCalories");
      print("Remaining Calories: $remainingCalories");
    });
  }

  void subscribeToTickExercises() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    String userId = currentUser.uid;

    _tickExercisesSubscription = FirebaseFirestore.instance
        .collection('checkedWorkouts')
        .doc(userId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          tickExercises = snapshot['tickExercises'] ?? 0;
        });
      }
    });
  }

  Future<void> fetchCurrentDayIndex() async {
    int currentIndex = await _timeHandler.getCurrentDayIndex();
    print('Current Day Index: $currentIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TopSectionHome(
                  onShopPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Shop(user: widget.user)),
                    );
                  },
                  onSettingPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Setting(user: widget.user)),
                    );
                  },
                ),
                CustomBanner(
                  text1: 'Welcome, ',
                  text2: displayName ?? 'User',
                  imageUrl: 'assets/images/Fitniwelcome.png',
                  bannerColor: const Color.fromARGB(255, 255, 239, 160),
                  shadowColor: const Color.fromARGB(255, 255, 131, 96),
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: HomeLog2(text: 'Diet Log'),
                    ),
                    Expanded(
                      child: HomeLog2(text: 'Workouts'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DietLog(
                        text1: '$totalCalories',
                        text2: ' left',
                        bannerColor: const Color.fromARGB(255, 255, 255, 255),
                        shadowColor: const Color.fromARGB(255, 255, 131, 96),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Diet(widget.user)),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: WorkoutLog(
                        text1: 'Completed',
                        text2: ' $tickExercises/10',
                        bannerColor: const Color.fromARGB(255, 255, 255, 255),
                        shadowColor: const Color.fromARGB(255, 255, 131, 96),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ExerciseScreen(widget.user)),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
