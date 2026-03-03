import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../frontendComponents/customBanner4.dart';
import '../../frontendComponents/goBackButton.dart';

class LogDiet extends StatefulWidget {
  const LogDiet({super.key});

  @override
  State<LogDiet> createState() => _LogDietState();
}

class _LogDietState extends State<LogDiet> {
  late Future<List<dynamic>> _futureData;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _futureData = Future.value([]);
  }

  Future<List<dynamic>> fetchData(String query) async {
    if (query.isEmpty) {
      return [];
    }
    var theQuery =
        "https://api.edamam.com/api/recipes/v2?type=public&q=${Uri.encodeComponent(query)}&app_id=94eae1d7&app_key=ba328c998104494ab3c083fdb2e6ff91";
    http.Response response = await http.get(Uri.parse(theQuery));
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body)['hits'];
      return responseBody;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 50.0),
              CustomBanner4(
                text: 'Search',
                textColor: const Color.fromRGBO(255, 131, 96, 1.0),
                bannerColor: const Color.fromARGB(255, 255, 239, 160),
                bannerHeight: 130,
                shadowColor: const Color.fromARGB(255, 255, 131, 96),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _futureData = fetchData(_searchController.text);
                        });
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        color: Color.fromRGBO(255, 131, 96, 1.0),
                        size: 30,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Image.asset(
                          "assets/images/loadingicon.gif",
                          width: 170,
                          height: 170,
                          gaplessPlayback: true,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<dynamic> foodItems = snapshot.data!;
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 20, right: 25, left: 25, bottom: 18),
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                              color: const Color.fromRGBO(255, 131, 96, 1.0),
                              width: 3.0),
                        ),
                        child: ListView.builder(
                          itemCount: foodItems.length,
                          itemBuilder: (BuildContext context, int index) {
                            String foodName =
                                foodItems[index]['recipe']['label'];
                            double caloriesDouble = foodItems[index]['recipe']
                                ['calories'] as double;
                            String recipeUri =
                                foodItems[index]['recipe']['uri'];
                            int yield =
                                foodItems[index]['recipe']['yield'].toInt();
                            caloriesDouble /= yield;

                            int calories = caloriesDouble.toInt();
                            double weight =
                                foodItems[index]['recipe']['totalWeight'];
                            weight /= yield;
                            int integerWeight = weight.toInt();

                            return ListTile(
                              title: Text(
                                foodName,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Color.fromRGBO(255, 131, 96, 1.0),
                                  fontFamily: 'Aristotellica',
                                  fontWeight: FontWeight.w100,
                                  height: 1,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Calories: $calories',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        fontFamily: 'Pines',
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    Text(
                                      'Grams: $integerWeight',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Color.fromRGBO(91, 91, 91, 1),
                                        fontFamily: 'Pines',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).pop([
                                  calories.toString(),
                                  foodName,
                                  recipeUri,
                                  integerWeight.toString()
                                ]);
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
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
