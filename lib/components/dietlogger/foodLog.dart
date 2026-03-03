import 'package:fitness/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './dietlogwidget.dart';

import '../../frontendComponents/primaryButtonMain.dart';
import '../../frontendComponents/goBackButton.dart';
import '../../frontendComponents/customBanner2.dart';
import '../../frontendComponents/customBanner3.dart';

class Diet extends StatefulWidget {
  final User user;

  const Diet(this.user, {super.key});

  @override
  State<Diet> createState() => _DietState();
}

class _DietState extends State<Diet> {
  int totalCalories = 0;
  String recipeUri = '';
  String totalCaloriesPrintable = '0';
  int consumedCalories = 0;
  List<List<String>> _data = [];
  final List<Map<String, dynamic>> _foodLog = [];

  @override
  void initState() {
    super.initState();
    fetchCaloricNeeds();
    fetchFoods();
  }

  void fetchCaloricNeeds() async {
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
        Map<String, dynamic> userData =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        setState(() {
          totalCalories = (userData['caloricNeed'] ?? 0).toInt();

          totalCaloriesPrintable = totalCalories.toString();
        });
      } else {
        print('No user data found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void fetchFoods() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      print('Fetching Food for ${widget.user.uid}');
      QuerySnapshot querySnapshot = await firestore
          .collection('foodLogs')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Logged food found');
        Map<String, dynamic> loggedFood =
            querySnapshot.docs.first.data() as Map<String, dynamic>;

        print('Logged Food Data: $loggedFood');

        setState(() {
          _data = (loggedFood['foodLog'] as List<dynamic>).map((item) {
            Map<String, dynamic> foodItem = item as Map<String, dynamic>;
            return [
              foodItem['calories'].toString(),
              foodItem['uri'] as String,
              foodItem['name'] as String,
              foodItem['weight'].toString(),
            ];
          }).toList();

          consumedCalories = loggedFood['consumedCalories'] ?? 0;
          totalCalories -= consumedCalories;
          totalCaloriesPrintable = totalCalories.toString();
        });
      } else {
        print('No logged food found');
      }
    } catch (e) {
      print('Error fetching food: $e');
    }
  }

  Future<void> _receiveData(BuildContext context) async {
    final List<String>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LogDiet(),
      ),
    );

    if (result != null && result.length == 4) {
      setState(() {
        _data.add(result);
        consumedCalories += int.parse(result[0]);
        totalCalories -= int.parse(result[0]);
        totalCaloriesPrintable = totalCalories.toString();
      });
    }
  }

  void submitFoodLog(List<List<String>> data) {
    _foodLog.clear();
    for (var foodItem in data) {
      _foodLog.add({
        'weight': int.parse(foodItem[3]),
        'name': foodItem[2],
        'uri': foodItem[1],
        'calories': int.parse(foodItem[0]),
      });
    }
    print('Storing Food Log: $_foodLog');
    FirestoreService()
        .addFoodLog(widget.user.uid, _foodLog, consumedCalories, totalCalories);
    Navigator.pop(context);
  }

  void _removeItem(int index) {
    setState(() {
      consumedCalories -= int.parse(_data[index][0]);
      totalCalories += int.parse(_data[index][0]);
      totalCaloriesPrintable = totalCalories.toString();
      _data.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                const CustomBanner2(
                  text: "Today's Meal",
                  imageUrl: 'assets/images/fitnidiet.png',
                  textColor: Colors.white,
                  bannerColor: Color.fromARGB(255, 255, 131, 96),
                  shadowColor: Color.fromARGB(255, 201, 87, 54),
                  bannerHeight: 130,
                  imageHeight: 150,
                ),
                const SizedBox(height: 20.0),
                CustomBanner3(
                  text1: 'Calories Left',
                  text2: totalCaloriesPrintable,
                  bannerColor: const Color.fromARGB(255, 255, 239, 160),
                  shadowColor: const Color.fromARGB(255, 255, 131, 96),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 10, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Foods',
                        style: TextStyle(
                          fontSize: 40,
                          color: Color.fromRGBO(255, 131, 96, 1.0),
                          fontFamily: 'Aristotellica',
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _receiveData(context);
                        },
                        child: Image.asset(
                          'assets/icons/addicon.png',
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      top: 8, right: 25, left: 25, bottom: 10),
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                        color: const Color.fromRGBO(255, 131, 96, 1.0),
                        width: 3.0),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: _data.asMap().entries.map((entry) {
                          int index = entry.key;
                          List<String> food = entry.value;

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            food[1],
                                            style: const TextStyle(
                                              fontSize: 32,
                                              color: Color.fromRGBO(
                                                  255, 131, 96, 1.0),
                                              fontFamily: 'Aristotellica',
                                              fontWeight: FontWeight.w100,
                                              height: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _removeItem(index);
                                      },
                                      child: Image.asset(
                                        'assets/icons/delete.png',
                                        height: 35.0,
                                        width: 35.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        "Calories: ${food[0]}",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromRGBO(91, 91, 91, 1),
                                          fontFamily: 'Pines',
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Text(
                                        "Grams: ${food[3]}",
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Color.fromRGBO(91, 91, 91, 1),
                                          fontFamily: 'Pines',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  height: 2.0,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 131, 96, 1.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButtonMain(
                    label: 'Log Foods',
                    onPressed: () {
                      submitFoodLog(_data);
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
