import 'package:mocktail/mocktail.dart';
import 'package:moms_list/app/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService;

/// A signed-in user for tests.
const testUser = AuthUser(
  id: 'mom',
  displayName: 'Mom',
  email: 'mom@example.com',
);
