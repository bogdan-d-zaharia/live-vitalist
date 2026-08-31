abstract final class AppRoutes {
  static const root = '/';
  static const onboarding = '/onboarding';
  static const onboardingPath = 'onboarding';
  static const home = '/home';
  static const settings = '/home/settings';
  static const settingsPath = 'settings';
  static const mealEditor = '/home/meal-editor';
  static const mealEditorPath = 'meal-editor';
  static const search = '/search';
  static const initializationError = '/initialization-error';

  static String mealEditorLocation({
    required String mealKey,
    required DateTime date,
  }) {
    return Uri(
      path: mealEditor,
      queryParameters: {
        'mealKey': mealKey,
        'date': date.toIso8601String(),
      },
    ).toString();
  }
}
