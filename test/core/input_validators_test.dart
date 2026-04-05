import 'package:architecture_learning/core/validation/input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputValidators', () {
    test('validateEmail returns error for invalid email', () {
      expect(
        InputValidators.validateEmail('invalid-email'),
        'Enter a valid email',
      );
    });

    test('validatePassword enforces minimum length', () {
      expect(
        InputValidators.validatePassword('123'),
        'Password must be at least 6 characters',
      );
    });

    test('validateName accepts a valid name', () {
      expect(InputValidators.validateName('Fazle Rabbi'), isNull);
    });
  });
}
