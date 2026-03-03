import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> beginningOfTime() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("User not logged in.");
    return;
  }

  Map<String, String> avatarData = {
    'hair': 'assets/avatar/hair/hair2.png',
    'head': 'assets/avatar/heads/head2.png',
    'legs': 'assets/avatar/legs/legs1.png',
    'shoes': 'assets/avatar/shoes/shoe2.png',
    'torso': 'assets/avatar/torso/torso1.png',
    'userId': currentUser.uid,
  };

  try {
    await FirebaseFirestore.instance.collection('avatars').add(avatarData);
    print("Avatar document added successfully.");
  } catch (e) {
    print("Error adding document: $e");
  }
}

Future<void> initializeFitniQuest() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("User not logged in.");
    return;
  }

  Map<String, dynamic> fitniQuestData = {
    'fitopians': 500,
    'proteinBars': 20,
    'questScore': 0,
    'rank': 'The New Guy',
    'level': 1,
    'caloriesBurned': 0,
    'daysTracked': 0,
    'streak': 0,
    'workoutsCompleted': 0,
    'userId': currentUser.uid,
    'bossesDefeated': 0,
  };

  try {
    await FirebaseFirestore.instance
        .collection('fitniQuest')
        .add(fitniQuestData);
    print("fitniQuest document added successfully.");
  } catch (e) {
    print("Error adding document: $e");
  }
}

Future<void> initializeOwnedAssets() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("User not logged in.");
    return;
  }

  Map<String, dynamic> ownedAssetsData = {
    'hair': ['assets/avatar/hair/hair1.png', 'assets/avatar/hair/hair2.png'],
    'head': ['assets/avatar/heads/head1.png', 'assets/avatar/heads/head2.png'],
    'legs': ['assets/avatar/legs/legs1.png', 'assets/avatar/legs/legs2.png'],
    'shoes': ['assets/avatar/shoes/shoe1.png', 'assets/avatar/shoes/shoe2.png'],
    'torso': [
      'assets/avatar/torso/torso1.png',
      'assets/avatar/torso/torso2.png'
    ],
    'multipliers': [],
    'userId': currentUser.uid,
  };

  try {
    await FirebaseFirestore.instance
        .collection('ownedAssets')
        .add(ownedAssetsData);
    print("ownedAssets document added successfully.");
  } catch (e) {
    print("Error adding document: $e");
  }
}

// Future<void> initializeStoryCollection() async {
//   User? currentUser = FirebaseAuth.instance.currentUser;

//   if (currentUser == null) {
//     print("User not logged in.");
//     return;
//   }

//   Map<String, dynamic> storyCollectionData = {
//     'bossesDefeated': 0,
//     'claimedDays': [],
//   };

//   try {
//     await FirebaseFirestore.instance
//         .collection('storyCollection')
//         .doc(currentUser.uid)
//         .set(storyCollectionData);
//     print("storyCollection document set successfully.");
//   } catch (e) {
//     print("Error setting document: $e");
//   }
// }

Future<void> initializeStoryCollection() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("User not logged in.");
    return;
  }

  Map<String, dynamic> storyCollectionData = {
    'userId': currentUser.uid, // Add the userId here
    'bossesDefeated': 0,
    'claimedDays': [],
  };

  try {
    await FirebaseFirestore.instance
        .collection('storyCollection')
        .doc(currentUser.uid)
        .set(storyCollectionData);
    print("storyCollection document set successfully.");
  } catch (e) {
    print("Error setting document: $e");
  }
}

Future<void> initializeFoodLogs() async {
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser == null) {
    print("User not logged in.");
    return;
  }

  Map<String, dynamic> foodLogsData = {
    'consumedCalories': 0,
    'foodLog': [],
    'totalCalories': 0,
    'userId': currentUser.uid,
  };

  try {
    await FirebaseFirestore.instance.collection('foodLogs').add(foodLogsData);
    print("foodLogs document added successfully.");
  } catch (e) {
    print("Error adding document: $e");
  }
}

Future<void> initializeAll() async {
  await beginningOfTime();
  await initializeFitniQuest();
  await initializeOwnedAssets();
  await initializeStoryCollection();
  // await initializeFoodLogs();
  print("All initialization functions completed.");
}
