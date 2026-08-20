class AppConstants {
  static const String baseUrl = 'https://reqres.in';
  static const String loginEndpoint = '/api/login?delay=5';
  static const String usersEndpoint = '/api/users?page=';

  static const String tokenPrefsKey = 'auth_token';

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
  );

  static final RegExp passwordRegex = RegExp(r'^[A-Za-z\d]{6,10}$');
}
