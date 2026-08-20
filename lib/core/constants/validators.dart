import 'app_constants.dart';

class Validators {
  static bool isValidEmail(String email) =>
      AppConstants.emailRegex.hasMatch(email);

  static bool isValidPassword(String password) =>
      AppConstants.passwordRegex.hasMatch(password);
}
