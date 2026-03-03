import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductBox extends StatefulWidget {
  final String title;
  final String type;
  final List<Map<String, String>> products;
  final User user;
  final Function(int) updateFitopians;

  const ProductBox({
    Key? key,
    required this.title,
    required this.type,
    required this.products,
    required this.user,
    required this.updateFitopians,
  }) : super(key: key);

  @override
  _ProductBoxState createState() => _ProductBoxState();
}

class _ProductBoxState extends State<ProductBox> {
  late int userFitopians;
  bool isAlreadyOwned = false;

  @override
  void initState() {
    super.initState();
    getUserFitopians();
  }

  Future<void> getUserFitopians() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        int fitniFitopians = querySnapshot.docs.first['fitopians'];
        print('snap shot exist');
        setState(() {
          userFitopians = fitniFitopians;
        });
        print('FitniPoints: $userFitopians');
      }
    } catch (e) {
      print('Error fetching fitniPoints: $e');
    }
  }

  // Future<void> getUserFitopians() async {
  //   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //       .collection('fitniQuest')
  //       .doc(widget.user.uid)
  //       .get();
  //   Map<String, dynamic>? data = userSnapshot.data() as Map<String, dynamic>?;
  //   print(data?['fitopians']);
  //   setState(() {
  //     userFitopians = data?['fitopians'] ?? 0;
  //   });
  // }

  Future<bool> checkOwnership(String imagePath) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('ownedAssets')
          .where('userId', isEqualTo: widget.user.uid)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return false;
      }

      DocumentSnapshot ownedAssetsSnapshot = querySnapshot.docs.first;
      Map<String, dynamic>? data =
          ownedAssetsSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data.containsKey(widget.type)) {
        List<dynamic> items = data[widget.type];
        return items.contains(imagePath);
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking ownership: $e');
      return false;
    }
  }

  void buyItem(String imagePath, int productPrice) async {
    print('calling buy item');

    try {
      QuerySnapshot fitniQuestSnapshot = await FirebaseFirestore.instance
          .collection('fitniQuest')
          .where('userId', isEqualTo: widget.user.uid)
          .limit(1)
          .get();

      if (fitniQuestSnapshot.docs.isNotEmpty) {
        print('FitniQuest snapshot found');
        int fitopians = fitniQuestSnapshot.docs.first['fitopians'];
        print('Fitopians: $fitopians');

        int updatedFitopians = fitopians - productPrice;
        print('Updated Fitopians: $updatedFitopians');

        await FirebaseFirestore.instance
            .collection('fitniQuest')
            .doc(fitniQuestSnapshot.docs.first.id)
            .update({'fitopians': updatedFitopians});
        print('Updated FitniQuest with new Fitopians');

        QuerySnapshot ownedAssetsSnapshot = await FirebaseFirestore.instance
            .collection('ownedAssets')
            .where('userId', isEqualTo: widget.user.uid)
            .get();
        print('Owned Assets snapshot fetched');

        if (ownedAssetsSnapshot.docs.isEmpty) {
          print('No owned assets found, creating new record');
          await FirebaseFirestore.instance.collection('ownedAssets').add({
            'userId': widget.user.uid,
            widget.type: [imagePath],
          });
          print('New owned asset added');
        } else {
          DocumentSnapshot ownedAssetsDoc = ownedAssetsSnapshot.docs.first;
          Map<String, dynamic>? ownedAssetsData =
              ownedAssetsDoc.data() as Map<String, dynamic>?;
          print('Owned Assets data: $ownedAssetsData');

          if (ownedAssetsData != null &&
              ownedAssetsData.containsKey(widget.type)) {
            List<dynamic> items = ownedAssetsData[widget.type];
            print('Current items: $items');
            items.add(imagePath);
            print('Items after adding new imagePath: $items');

            await FirebaseFirestore.instance
                .collection('ownedAssets')
                .doc(ownedAssetsDoc.id)
                .update({widget.type: items});
            print('Owned assets updated with new items');
          } else {
            await FirebaseFirestore.instance
                .collection('ownedAssets')
                .doc(ownedAssetsDoc.id)
                .update({
              widget.type: [imagePath]
            });
            print('Owned assets updated with new type');
          }
        }

        setState(() {
          userFitopians = updatedFitopians;
          isAlreadyOwned = true;
        });
        print('State updated with new Fitopians and ownership status');

        widget.updateFitopians(updatedFitopians);
        print('Widget updated with new Fitopians');

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Purchase Successful'),
              content: const Text('You have successfully purchased!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print('Purchase success dialog shown');
      } else {
        print('No FitniQuest document found for the user');
      }
    } catch (e) {
      print('Error buying item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: const Color.fromRGBO(248, 153, 80, 1),
          width: 2.0,
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 40.0,
                fontFamily: 'Aristotellica',
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 131, 96, 1),
              ),
            ),
          ),
          Container(
            height: 2.4,
            color: const Color.fromRGBO(255, 131, 96, 1),
            margin: const EdgeInsets.only(bottom: 8.0),
          ),
          if (widget.products.length == 1)
            GestureDetector(
              onTap: () async {
                final product = widget.products.first;
                bool alreadyOwned = await checkOwnership(product['imagePath']!);
                int productPrice = int.parse(product['price']!);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 100.0,
                            child: Image.asset(
                              product['imagePath']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            product['name']!,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontFamily: 'Pines',
                              color: Color.fromRGBO(68, 74, 79, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '\$${product['price']}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Pines',
                              color: Color.fromRGBO(68, 74, 79, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            product['description']!,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Pines',
                              color: Color.fromRGBO(68, 74, 79, 1),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          if (alreadyOwned)
                            const Text(
                              'Item already owned',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Pines',
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else if (userFitopians < productPrice)
                            const Text(
                              'Not enough points',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'Pines',
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                buyItem(product['imagePath']!, productPrice);

                                Navigator.of(context).pop();
                              },
                              child: const Text('Buy'),
                            ),
                        ],
                      ),
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border: Border.all(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      width: 2.0,
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20.0),
                      Container(
                        height: 150.0,
                        child: Image.asset(
                          widget.products.first['imagePath']!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 18.0),
                      Text(
                        '\$${widget.products.first['price']}',
                        style: const TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'Pines',
                          color: Color.fromRGBO(68, 74, 79, 1),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return GestureDetector(
                  onTap: () async {
                    bool alreadyOwned =
                        await checkOwnership(product['imagePath']!);
                    int productPrice = int.parse(product['price']!);

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 70.0,
                                child: Image.asset(
                                  product['imagePath']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                product['name']!,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Pines',
                                  color: Color.fromRGBO(68, 74, 79, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                '\$${product['price']}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Pines',
                                  color: Color.fromRGBO(68, 74, 79, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                product['description']!,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: 'Pines',
                                  color: Color.fromRGBO(68, 74, 79, 1),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16.0),
                              if (alreadyOwned)
                                const Text(
                                  'Item already owned',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Pines',
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              else if (userFitopians < productPrice)
                                const Text(
                                  'Not enough points',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontFamily: 'Pines',
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              else
                                ElevatedButton(
                                  onPressed: () {
                                    buyItem(
                                        product['imagePath']!, productPrice);

                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Buy'),
                                ),
                            ],
                          ),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(
                        color: const Color.fromRGBO(248, 153, 80, 1),
                        width: 2.0,
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: widget.type == 'shoes' ? 34 : 58.0,
                          child: Image.asset(
                            product['imagePath']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          '\$${product['price']}',
                          style: const TextStyle(
                            fontSize: 13.0,
                            fontFamily: 'Pines',
                            color: Color.fromRGBO(68, 74, 79, 1),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
