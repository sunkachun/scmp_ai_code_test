import 'package:flutter_test/flutter_test.dart';
import 'package:scmp_ai_code_test/core/constants/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts valid email', () {
      expect(Validators.isValidEmail('eve.holt@reqres.in'), isTrue);
    });

    test('rejects email without @', () {
      expect(Validators.isValidEmail('not-an-email'), isFalse);
    });

    test('rejects empty email', () {
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.password', () {
    test('accepts 6 alphanumeric characters', () {
      expect(Validators.isValidPassword('abc123'), isTrue);
    });

    test('accepts 10 alphanumeric characters', () {
      expect(Validators.isValidPassword('cityslicka'), isTrue);
    });

    test('rejects shorter than 6 characters', () {
      expect(Validators.isValidPassword('abc12'), isFalse);
    });

    test('rejects longer than 10 characters', () {
      expect(Validators.isValidPassword('abc12345678'), isFalse);
    });

    test('rejects special characters', () {
      expect(Validators.isValidPassword('abc@123'), isFalse);
    });
  });
}
