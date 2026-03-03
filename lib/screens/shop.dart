import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './avatarShop.dart';
import './featuredItem.dart';
import './powerupsShop.dart';
import '../../frontendComponents/topBar.dart';
import '../../frontendComponents/goBackButton.dart';

class Shop extends StatefulWidget {
  final User user;

  const Shop({Key? key, required this.user}) : super(key: key);

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  int fitniPoints = 0;
  int proteinBars = 0;
  int fitopians = 0;

  @override
  void initState() {
    super.initState();
    fetchShopData();
  }

  void updateFitopiansAgain(int newFitopians) {
    setState(() {
      fitopians = newFitopians;
    });
  }

  Future<void> fetchShopData() async {
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
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width + 80,
                        height: MediaQuery.of(context).size.height / 5,
                        child: Image.asset(
                          'assets/images/shopBanner.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 10,
                        child: GoBackButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeaturedItemShop(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/featureditem.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AvatarShop(
                              user: widget.user,
                              updateFitopiansAgain: updateFitopiansAgain,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/avatarBanner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PowerUpShop(
                              user: widget.user,
                            ),
                          ),
                        );
                      },
                      child: Image.asset(
                        'assets/images/powerupbanner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
