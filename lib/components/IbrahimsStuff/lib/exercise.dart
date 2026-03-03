import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../frontendComponents/customBanner2.dart';
import '../../../frontendComponents/goBackButton.dart';
import '../../../frontendComponents/primaryButtonMain.dart';
import '../../../services/firestore.dart';
import '../../timer/timeHandler.dart';

class ExerciseScreen extends StatefulWidget {
  final User user;

  const ExerciseScreen(this.user, {super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<dynamic>? _exercises;
  List<bool> _exerciseCheckedState = [];
  final List<String> _checkedExerciseNames = [];
  final List<String> _checkedExerciseSets = [];
  final List<int> _checkedExerciseFitniScore = [];
  bool _needsDumbbell = false;
  String _difficulty = '';
  int currentDayIndex = 1;
  final TimeHandler timeHandler = TimeHandler();

  int _totalExercises = 0;
  int _tickExercises = 0;

  @override
  void initState() {
    super.initState();
    loadDayIndex();
    fetchUserPreferences();
    fetchCheckedWorkouts();
  }

  Future<void> loadDayIndex() async {
    final int index = await timeHandler.getDay();
    setState(() {
      currentDayIndex = index;
    });
  }

  void fetchUserPreferences() async {
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
          String difficulty = userData['difficulty'] ?? 'Beginner';
          bool needsDumbbell = userData['needsDumbell'] ?? false;
          print('User preferences: $difficulty, $needsDumbbell');
          setState(() {
            _difficulty = difficulty;
            _needsDumbbell = needsDumbbell;
          });

          if (_difficulty == 'Beginner' && !_needsDumbbell) {
            loadExercises('Beginner.json');
            print('Loading beginner exercises');
          } else if (_difficulty == 'Intermediate' && !_needsDumbbell) {
            loadExercises('Intermediate.json');
          } else if (_difficulty == 'Advanced' && !_needsDumbbell) {
            loadExercises('Hard.json');
          } else if (_needsDumbbell && _difficulty == 'Beginner') {
            print('Loading dumbbell exercises for Beginners');
            loadExercises('D_Beginner.json');
          } else if (_needsDumbbell && _difficulty == 'Intermediate') {
            loadExercises('D_Intermediate.json');
          } else if (_needsDumbbell && _difficulty == 'Advanced') {
            loadExercises('D_Hard.json');
          } else {
            print('Invalid user preferences');
          }
        } else {
          print('User data is null');
        }
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user preferences: $e');
    }
  }

  void fetchCheckedWorkouts() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching checked workouts for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('checkedWorkouts')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Checked workouts found');
        Map<String, dynamic>? checkedWorkoutsData =
            querySnapshot.docs.first.data() as Map<String, dynamic>?;

        if (checkedWorkoutsData != null) {
          List<dynamic> workouts = checkedWorkoutsData['workoutNames'] ?? [];
          int totalExercises = checkedWorkoutsData['totalExercises'] ?? 0;
          int tickExercises = checkedWorkoutsData['tickExercises'] ?? 0;

          print('Checked workouts: $workouts');
          print('Total exercises: $totalExercises');
          print('Ticked exercises: $tickExercises');

          setState(() {
            _checkedExerciseNames.clear();
            _checkedExerciseNames.addAll(workouts.cast<String>());
            _totalExercises = totalExercises;
            _tickExercises = tickExercises;
          });
        } else {
          print('Checked workouts data is null');
        }
      } else {
        print('No checked workouts found');
      }
    } catch (e) {
      print('Error fetching checked workouts: $e');
    }
  }

  void submitSelectedExercises() {
    _checkedExerciseFitniScore.clear();

    int totalExercises = _exercises?.length ?? 0;
    int tickExercises = 0;

    for (int i = 0; i < _exercises!.length; i++) {
      if (_checkedExerciseNames.contains(_exercises![i]['name'])) {
        _checkedExerciseFitniScore.add(_exercises![i]['fitni_score']);
        tickExercises++;
      }
    }

    print('Selected exercises: $_checkedExerciseNames');
    print('Fitni Scores: $_checkedExerciseFitniScore');
    print('Total exercises: $totalExercises');
    print('Ticked exercises: $tickExercises');

    FirestoreService().updateCheckedWorkouts(
      widget.user.uid,
      _checkedExerciseNames,
      _checkedExerciseFitniScore,
      totalExercises,
      tickExercises,
    );

    Navigator.pop(context);
  }

  void loadExercises(String jsonFile) async {
    try {
      print('Loading exercises from: $jsonFile');
      String jsonString =
          await rootBundle.loadString('assets/templates/$jsonFile');

      Map<String, dynamic> data = json.decode(jsonString);
      String currentDay = currentDayIndex.toString();
      String dayKey = 'Day_$currentDay';
      print('Day key: $dayKey');
      if (data.containsKey(dayKey)) {
        _exercises = data[dayKey]['exercises'];
        _exerciseCheckedState = List.generate(
          _exercises!.length,
          (index) => false,
        );
        setState(() {});
      } else {
        print('Exercises not found for day: $dayKey');
      }
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60.0),
              const CustomBanner2(
                text: "Today's Workout",
                imageUrl: 'assets/images/exerciseFitni.png',
                textColor: Color.fromARGB(255, 255, 131, 96),
                bannerColor: Color.fromARGB(255, 255, 239, 160),
                shadowColor: Color.fromARGB(255, 255, 131, 96),
                bannerHeight: 130,
                imageHeight: 150,
              ),
              if (_exercises != null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20, right: 25, left: 25),
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(
                          color: const Color.fromRGBO(255, 131, 96, 1.0),
                          width: 3.0),
                    ),
                    child: ListView.builder(
                      itemCount: _exercises!.length,
                      itemBuilder: (context, index) {
                        final exerciseName = _exercises![index]['name'];
                        final isChecked =
                            _checkedExerciseNames.contains(exerciseName);

                        return Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                const Color.fromRGBO(255, 255, 255, 1),
                            checkboxTheme: CheckboxThemeData(
                              fillColor:
                                  WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return const Color.fromRGBO(
                                      255, 131, 96, 1.0);
                                }
                                return const Color.fromRGBO(255, 255, 255, 1);
                              }),
                              side: WidgetStateBorderSide.resolveWith(
                                (states) => const BorderSide(
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  width: 2,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: CheckboxListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    exerciseName,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      color: Color.fromRGBO(255, 131, 96, 1.0),
                                      fontFamily: 'Aristotellica',
                                      fontWeight: FontWeight.w100,
                                      height: 1.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.info_outline,
                                      color: Color.fromRGBO(91, 91, 91, 1),
                                    ),
                                    onPressed: () {
                                      final instructions =
                                          _exercises![index]['instructions'];
                                      final restPeriod =
                                          _exercises![index]['rest_period'];

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              exerciseName,
                                              style: const TextStyle(
                                                fontSize: 28,
                                                color: Color.fromRGBO(
                                                    255, 131, 96, 1.0),
                                                fontFamily: 'Aristotellica',
                                                fontWeight: FontWeight.w100,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Instructions: $instructions',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        91, 91, 91, 1),
                                                    fontFamily: 'Pines',
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Rest Period: $restPeriod',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    color: Color.fromRGBO(
                                                        91, 91, 91, 1),
                                                    fontFamily: 'Pines',
                                                  ),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                    fontSize: 28,
                                                    color: Color.fromRGBO(
                                                        255, 131, 96, 1.0),
                                                    fontFamily: 'Aristotellica',
                                                    fontWeight: FontWeight.w100,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_exercises![index]['sets']}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color.fromRGBO(91, 91, 91, 1),
                                    fontFamily: 'Pines',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 131, 96, 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ],
                            ),
                            value: isChecked,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value != null && value) {
                                  _checkedExerciseNames.add(exerciseName);
                                } else {
                                  _checkedExerciseNames.remove(exerciseName);
                                }
                                _exerciseCheckedState[index] = value ?? false;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: PrimaryButtonMain(
                  label: 'Submit',
                  onPressed: () {
                    submitSelectedExercises();
                  },
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
