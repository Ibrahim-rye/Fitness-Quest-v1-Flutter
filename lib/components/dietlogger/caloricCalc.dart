double calculateCaloricIntake({
  required String gender,
  required int age,
  required double weight,
  required double height,
  required String activityLevel,
  required String goal,
}) {
  double calculateBMR(String gender, int age, double weight, double height) {
    if (gender == 'Male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  double adjustForActivityLevel(double bmr, String activityLevel) {
    double activityFactor;

    switch (activityLevel) {
      case 'Sedentary':
        activityFactor = 1.2;
        break;
      case 'Light':
        activityFactor = 1.375;
        break;
      case 'Moderate':
        activityFactor = 1.55;
        break;
      case 'Very Active':
        activityFactor = 1.725;
        break;
      case 'Super Active':
        activityFactor = 1.9;
        break;
      default:
        activityFactor = 1.2;
    }

    return bmr * activityFactor;
  }

  double adjustForGoal(double caloricNeeds, String goal) {
    switch (goal) {
      case 'Lose weight':
        return caloricNeeds - 500;
      case 'Gain weight':
        return caloricNeeds + 500;
      case 'Maintain weight':
      default:
        return caloricNeeds;
    }
  }

  double bmr = calculateBMR(gender, age, weight, height);

  double caloricNeeds = adjustForActivityLevel(bmr, activityLevel);

  return adjustForGoal(caloricNeeds, goal);
}
