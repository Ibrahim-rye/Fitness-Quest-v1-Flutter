import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../frontendComponents/topBar.dart';
import '../../frontendComponents/shopSection.dart';

class FeaturedItemShop extends StatefulWidget {
  final User user;

  const FeaturedItemShop({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _FeaturedItemShopState createState() => _FeaturedItemShopState();
}

class _FeaturedItemShopState extends State<FeaturedItemShop> {
  int fitniPoints = 0;
  int proteinBars = 0;
  int fitopians = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void updateFitopians(int newFitopians) {
    setState(() {
      fitopians = newFitopians;
    });
  }

  Future<void> fetchUserData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        int fitniScore = querySnapshot.docs.first['questScore'];
        int fitniProteinBars = querySnapshot.docs.first['proteinBars'];
        int fitniFitopians = querySnapshot.docs.first['fitopians'];
        print('snap shot exist');
        setState(() {
          fitniPoints = fitniScore;
          proteinBars = fitniProteinBars;
          fitopians = fitniFitopians;
        });
        print('FitniPoints: $fitniPoints');
      }
    } catch (e) {
      print('Error fetching fitniPoints: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 131, 96, 1),
      body: Column(
        children: [
          TopBar(
            barColor: const Color.fromARGB(255, 136, 219, 119),
            shadowColor: const Color.fromARGB(255, 90, 182, 72),
            item1Label: fitniPoints.toString(),
            item1Color: Colors.white,
            item1Image: 'assets/icons/fp.png',
            item2Label: proteinBars.toString(),
            item2Color: Colors.white,
            item2Image: 'assets/icons/pb.png',
            item3Label: fitopians.toString(),
            item3Color: Colors.white,
            item3Image: 'assets/icons/fitopians.png',
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  ProductBox(
                    title: 'Featured Items',
                    type: 'multipliers',
                    products: const [
                      {
                        'name': 'Featured Item 1',
                        'price': '300',
                        'imagePath': 'assets/images/icebreaker.png',
                        'description': 'Description for featured item 1.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
