import 'package:mocktail/mocktail.dart';
import 'package:moms_list/auth/auth.dart';

class MockAuthRepository extends Mock implements AuthRepository;

/// A signed-in user for tests.
const testUser = AuthUser(
  id: 'mom',
  displayName: 'Mom',
  email: 'mom@example.com',
  method: SignInMethod.apple,
);
