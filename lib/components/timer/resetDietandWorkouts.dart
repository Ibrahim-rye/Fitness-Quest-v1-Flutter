import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void deletetheUniverse() async {
  print('DTU Called');
  final User user = FirebaseAuth.instance.currentUser!;
  await calculateAndUpdateFitniScores(user.uid);
}

Future<void> calculateAndUpdateFitniScores(String userId) async {
  int totalFitniScore = 0;
  int workoutsCompletedToday = 0;

  final workoutScores = await calculateWorkoutFitniScores(userId);
  totalFitniScore += workoutScores['fitniScore'] ?? 0;
  workoutsCompletedToday += workoutScores['workoutsCompleted'] ?? 0;

  totalFitniScore += await calculateDietFitniScores(userId);

  QuerySnapshot fitniQuestQuery = await FirebaseFirestore.instance
      .collection('fitniQuest')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (fitniQuestQuery.docs.isNotEmpty) {
    DocumentSnapshot fitniQuestSnapshot = fitniQuestQuery.docs.first;
    Map<String, dynamic>? fitniQuestData =
        fitniQuestSnapshot.data() as Map<String, dynamic>?;

    int currentStreak = fitniQuestData?['streak'] ?? 1;
    int questScore = fitniQuestData?['questScore'] ?? 0;
    int daysTracked = fitniQuestData?['daysTracked'] ?? 0;
    int caloriesBurned = fitniQuestData?['caloriesBurned'] ?? 0;
    int workoutsCompleted = fitniQuestData?['workoutsCompleted'] ?? 0;
    String rank = fitniQuestData?['rank'] ?? "The New Guy";

    if (totalFitniScore == 0) {
      currentStreak = 1;
    } else {
      currentStreak += 1;
      daysTracked += 1;
      if (daysTracked == 5) {
        rank = "The Town Rumor";
      } else if (daysTracked == 10) {
        rank = "The Famous Town Rumor";
      }
    }

    caloriesBurned += await getConsumedCalories(userId);

    workoutsCompleted += workoutsCompletedToday;
    questScore += totalFitniScore;

    await FirebaseFirestore.instance
        .collection('fitniQuest')
        .doc(fitniQuestSnapshot.id)
        .update({
      'questScore': questScore,
      'streak': currentStreak,
      'daysTracked': daysTracked,
      'caloriesBurned': caloriesBurned,
      'workoutsCompleted': workoutsCompleted,
      'rank': rank
    });
  } else {
    await FirebaseFirestore.instance.collection('fitniQuest').add({
      'userId': userId,
      'questScore': totalFitniScore,
      'streak': 1,
      'daysTracked': 0,
      'caloriesBurned': 0,
      'workoutsCompleted': workoutsCompletedToday,
      'rank': "The New Guy"
    });
  }
}

Future<Map<String, int>> calculateWorkoutFitniScores(String userId) async {
  int fitniScore = 0;
  int workoutCount = 0;
  int workoutsCompleted = 0;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('checkedWorkouts')
      .where('userId', isEqualTo: userId)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    DocumentSnapshot workoutSnapshot = querySnapshot.docs.first;
    Map<String, dynamic>? workoutData =
        workoutSnapshot.data() as Map<String, dynamic>?;

    List<int> workoutFitniScores =
        workoutData?['workoutFitniScores']?.cast<int>() ?? [];

    for (int score in workoutFitniScores) {
      fitniScore += score;
      workoutCount += 1;
    }

    await FirebaseFirestore.instance
        .collection('checkedWorkouts')
        .doc(workoutSnapshot.id)
        .update({
      'workoutFitniScores': [],
      'workoutNames': [],
      'tickExercises': 0,
      'totalExercises': 0
    });
  }

  return {'fitniScore': fitniScore, 'workoutsCompleted': workoutCount};
}

Future<int> calculateDietFitniScores(String userId) async {
  int fitniScore = 0;

  QuerySnapshot foodLogsSnapshot = await FirebaseFirestore.instance
      .collection('foodLogs')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  QuerySnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (foodLogsSnapshot.docs.isNotEmpty && userSnapshot.docs.isNotEmpty) {
    DocumentSnapshot foodLogSnapshot = foodLogsSnapshot.docs.first;
    Map<String, dynamic>? dietData =
        foodLogSnapshot.data() as Map<String, dynamic>?;
    int consumedCalories = dietData?['consumedCalories'] ?? 0;

    DocumentSnapshot userDocSnapshot = userSnapshot.docs.first;
    Map<String, dynamic>? userData =
        userDocSnapshot.data() as Map<String, dynamic>?;
    int requiredCalories = userData?['caloricNeed']?.toInt() ?? 0;

    int difference = (requiredCalories - consumedCalories).abs();

    if (difference < 100) {
      fitniScore = 100;
    } else if (difference < 200) {
      fitniScore = 80;
    } else if (difference < 500) {
      fitniScore = 50;
    } else {
      fitniScore = 0;
    }

    await FirebaseFirestore.instance
        .collection('foodLogs')
        .doc(foodLogSnapshot.id)
        .update({'foodLog': [], 'consumedCalories': 0, 'totalCalories': 0});
  }

  return fitniScore;
}

Future<int> getConsumedCalories(String userId) async {
  int consumedCalories = 0;

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('foodLogs')
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    Map<String, dynamic>? dietData =
        querySnapshot.docs.first.data() as Map<String, dynamic>?;
    consumedCalories = dietData?['consumedCalories'] ?? 0;
  }

  return consumedCalories;
}
