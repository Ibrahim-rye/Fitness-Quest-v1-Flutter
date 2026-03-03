import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference checkedWorkouts =
      FirebaseFirestore.instance.collection('checkedWorkouts');
  final CollectionReference foodLogs =
      FirebaseFirestore.instance.collection('foodLogs');
  final CollectionReference fitniQuest =
      FirebaseFirestore.instance.collection('fitniQuest');
  final CollectionReference avatars =
      FirebaseFirestore.instance.collection('avatars');

  Future<void> addCheckedWorkout(String userId, List<String> workoutName,
      int totalExercises, int tickExercises) {
    return checkedWorkouts.add({
      'userId': userId,
      'workoutName': workoutName,
      'totalExercises': totalExercises,
      'tickExercises': tickExercises,
    });
  }

  Future<void> updateFitniQuest(
      String userId,
      int questScore,
      int streak,
      int daysTracked,
      int caloriesBurned,
      int workoutsCompleted,
      String rank) async {
    final DocumentReference docRef = fitniQuest.doc(userId);

    try {
      await docRef.update({
        'questScore': FieldValue.increment(questScore),
        'streak': streak,
        'daysTracked': daysTracked,
        'caloriesBurned': FieldValue.increment(caloriesBurned),
        'workoutsCompleted': FieldValue.increment(workoutsCompleted),
        'rank': rank,
      });
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        await docRef.set({
          'userId': userId,
          'questScore': questScore,
          'streak': streak,
          'daysTracked': daysTracked,
          'caloriesBurned': caloriesBurned,
          'workoutsCompleted': workoutsCompleted,
          'rank': rank,
        });
      } else {
        rethrow;
      }
    }
  }

  Future<void> addFoodLog(
    String userId,
    List<Map<String, dynamic>> foodLog,
    int consumedCalories,
    int totalCalories,
  ) async {
    return foodLogs.doc(userId).set({
      'userId': userId,
      'foodLog': foodLog,
      'consumedCalories': consumedCalories,
      'totalCalories': totalCalories,
    });
  }

  Future<void> updateCheckedWorkouts(String userId, List<String> workoutNames,
      List<int> workoutFitniScores, int totalExercises, int tickExercises) {
    return checkedWorkouts.doc(userId).set({
      'userId': userId,
      'workoutNames': workoutNames,
      'workoutFitniScores': workoutFitniScores,
      'totalExercises': totalExercises,
      'tickExercises': tickExercises,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> addUser(
    String userId,
    String name,
    String nick,
    String age,
    String weight,
    String height,
    String activityLevel,
    bool needsDumbell,
    String difficulty,
    String gender,
    String goal,
    double caloricNeed,
  ) {
    return users.doc(userId).set({
      'userId': userId,
      'name': name,
      'nick': nick,
      'age': age,
      'weight': weight,
      'height': height,
      'activityLevel': activityLevel,
      'needsDumbell': needsDumbell,
      'difficulty': difficulty,
      'gender': gender,
      'goal': goal,
      'caloricNeed': caloricNeed,
    });
  }

  Future<void> updateAvatar(
    String userId,
    String hair,
    String head,
    String torso,
    String legs,
    String shoes,
  ) {
    return avatars.doc(userId).set({
      'userId': userId,
      'hair': hair,
      'head': head,
      'torso': torso,
      'legs': legs,
      'shoes': shoes,
    });
  }

  Future<DocumentSnapshot> getUser(String userId) {
    return users.doc(userId).get();
  }

  Future<void> updateUser(
    String userId, {
    String? name,
    String? nick,
    String? age,
    String? weight,
    String? height,
    String? activityLevel,
    bool? needsDumbell,
    String? difficulty,
    String? gender,
    String? goal,
    double? caloricNeed,
  }) {
    Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (nick != null) data['nick'] = nick;
    if (age != null) data['age'] = age;
    if (weight != null) data['weight'] = weight;
    if (height != null) data['height'] = height;
    if (activityLevel != null) data['activityLevel'] = activityLevel;
    if (needsDumbell != null) data['needsDumbell'] = needsDumbell;
    if (difficulty != null) data['difficulty'] = difficulty;
    if (gender != null) data['gender'] = gender;
    if (goal != null) data['goal'] = goal;
    if (caloricNeed != null) data['caloricNeed'] = caloricNeed;

    return users.doc(userId).update(data);
  }
}
