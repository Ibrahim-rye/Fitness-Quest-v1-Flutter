import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../frontendComponents/topBar.dart';
import '../../frontendComponents/shopSection.dart';

class AvatarShop extends StatefulWidget {
  final User user;
  final Function(int) updateFitopiansAgain;
  const AvatarShop({
    Key? key,
    required this.user,
    required this.updateFitopiansAgain,
  }) : super(key: key);

  @override
  _AvatarShopState createState() => _AvatarShopState();
}

class _AvatarShopState extends State<AvatarShop> {
  int fitniPoints = 0;
  int proteinBars = 0;
  int fitopians = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void updateFitopians(int newFitopians) {
    widget.updateFitopiansAgain(newFitopians);
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
                    title: 'Hair',
                    type: 'hair',
                    products: const [
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair3.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair4.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair5.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair6.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair7.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair8.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair9.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair10.png',
                        'description': 'Hair for your avatar.'
                      },
                      {
                        'name': 'Hair',
                        'price': '100',
                        'imagePath': 'assets/avatar/hair/hair11.png',
                        'description': 'Hair for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                  ProductBox(
                    title: 'Head',
                    type: 'head',
                    products: const [
                      {
                        'name': 'Head',
                        'price': '150',
                        'imagePath': 'assets/avatar/heads/head3.png',
                        'description': 'Head accessory for your avatar.'
                      },
                      {
                        'name': 'Head',
                        'price': '150',
                        'imagePath': 'assets/avatar/heads/head4.png',
                        'description': 'Head accessory for your avatar.'
                      },
                      {
                        'name': 'Head',
                        'price': '150',
                        'imagePath': 'assets/avatar/heads/head5.png',
                        'description': 'Head accessory for your avatar.'
                      },
                      {
                        'name': 'Head',
                        'price': '150',
                        'imagePath': 'assets/avatar/heads/head6.png',
                        'description': 'Head accessory for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                  ProductBox(
                    title: 'Torso',
                    type: 'torso',
                    products: const [
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso3.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso4.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso5.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso6.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso7.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso8.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso9.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                      {
                        'name': 'Torso',
                        'price': '200',
                        'imagePath': 'assets/avatar/torso/torso10.png',
                        'description': 'Torso accessory for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                  ProductBox(
                    title: 'Legs',
                    type: 'legs',
                    products: const [
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs3.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs4.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs5.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs6.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs7.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs8.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs9.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs10.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                      {
                        'name': 'Leg',
                        'price': '200',
                        'imagePath': 'assets/avatar/legs/legs11.png',
                        'description': 'Leg accessory for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  ),
                  ProductBox(
                    title: 'Shoes',
                    type: 'shoes',
                    products: const [
                      {
                        'name': 'Shoes',
                        'price': '200',
                        'imagePath': 'assets/avatar/shoes/shoe3.png',
                        'description': 'Shoes for your avatar.'
                      },
                      {
                        'name': 'Shoes',
                        'price': '200',
                        'imagePath': 'assets/avatar/shoes/shoes4.png',
                        'description': 'Shoes for your avatar.'
                      },
                      {
                        'name': 'Shoes',
                        'price': '200',
                        'imagePath': 'assets/avatar/shoes/shoe5.png',
                        'description': 'Shoes for your avatar.'
                      },
                      {
                        'name': 'Shoes',
                        'price': '200',
                        'imagePath': 'assets/avatar/shoes/shoe6.png',
                        'description': 'Shoes for your avatar.'
                      },
                      {
                        'name': 'Shoes',
                        'price': '200',
                        'imagePath': 'assets/avatar/shoes/shoe7.png',
                        'description': 'Shoes for your avatar.'
                      },
                    ],
                    user: widget.user,
                    updateFitopians: updateFitopians,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
