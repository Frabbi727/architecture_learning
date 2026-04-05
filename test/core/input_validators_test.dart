import 'package:architecture_learning/core/utils/input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputValidators', () {
    test('validateEmail returns error for invalid email', () {
      expect(
        InputValidators.validateEmail('invalid'),
        'Enter a valid email',
      );
    });

    test('validatePassword enforces minimum length', () {
      expect(
        InputValidators.validatePassword('123'),
        'Password must be at least 6 characters',
      );
    });

    test('validateName accepts a valid value', () {
      expect(InputValidators.validateName('Emily'), isNull);
    });
  });
}
