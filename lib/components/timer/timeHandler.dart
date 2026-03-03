import './resetDietandWorkouts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeHandler {
  final int numberOfDays = 3;

  Future<int> getCurrentDayIndex() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int storedIndex = prefs.getInt('dayIndex') ?? 1;
    print('Stored Index: $storedIndex');

    final String lastDate = prefs.getString('lastDate') ?? '';
    print('Last Date: $lastDate');

    final String currentDate =
        DateTime.now().toIso8601String().substring(0, 10);
    print('Current Date: $currentDate');

    if (lastDate != currentDate) {
      print(
          'New day detected, resetting index. Previous stored index: $storedIndex');
      final int newIndex = (storedIndex % numberOfDays) + 1;
      print('New Index: $newIndex');

      deletetheUniverse();

      await prefs.setInt('dayIndex', newIndex);
      await prefs.setString('lastDate', currentDate);

      print('Updated SharedPreferences with new index and date');
      return newIndex;
    } else {
      print('Same day detected, using stored index: $storedIndex');
      return storedIndex;
    }
  }

  Future<int> getDay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int storedIndex = prefs.getInt('dayIndex') ?? 1;
    print('Retrieved Day Index: $storedIndex');
    return storedIndex;
  }
}
