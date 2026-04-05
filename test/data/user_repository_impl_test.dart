import 'package:architecture_learning/core/result/result.dart';
import 'package:architecture_learning/data/datasources/user_remote_data_source.dart';
import 'package:architecture_learning/data/repositories/user_repository_impl.dart';
import 'package:architecture_learning/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRepositoryImpl', () {
    test('getUsers returns seeded users from data source', () async {
      final repository = UserRepositoryImpl(MockUserRemoteDataSource());

      final result = await repository.getUsers();

      expect(result, isA<Success<List<User>>>());
      expect((result as Success<List<User>>).data, hasLength(3));
    });

    test('createUser maps duplicate email to failure', () async {
      final repository = UserRepositoryImpl(MockUserRemoteDataSource());

      final result = await repository.createUser(
        const User(
          id: '',
          name: 'Another Ava',
          email: 'ava@company.dev',
          role: 'Designer',
        ),
      );

      expect(result, isA<Failure<User>>());
      expect((result as Failure<User>).message, 'Email already exists');
    });

    test('deleteUser returns failure for missing id', () async {
      final repository = UserRepositoryImpl(MockUserRemoteDataSource());

      final result = await repository.deleteUser('missing-id');

      expect(result, isA<Failure<void>>());
      expect((result as Failure<void>).message, 'User not found');
    });
  });
}
